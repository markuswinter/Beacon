<?php

require(dirname(__FILE__, 3) . '/framework/loader.php');
header('Content-Type: text/plain');
http_response_code(400);

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
	http_response_code(405);
	echo 'Method not allowed';
	exit;
}

$endpoint_secret = BeaconCommon::GetGlobal('Stripe_Webhook_Secret');
$api_secret = BeaconCommon::GetGlobal('Stripe_Secret_Key');
$body = @file_get_contents('php://input');
$signature = $_SERVER['HTTP_STRIPE_SIGNATURE'];

$signature_parts = explode(',', $signature);
$signature_values = array();
foreach ($signature_parts as $part) {
	list($key, $value) = explode('=', trim($part), 2);
	$signature_values[$key] = $value;
}
$time = $signature_values['t'];
$signature_hex = $signature_values['v1'];

$signed_payload = $time . '.' . $body;
$expected_signature = hash_hmac('sha256', $time . '.' . $body, $endpoint_secret);
if ($signature_hex != $expected_signature) {
	echo 'Invalid signature';
	exit;
}

$json = json_decode($body, true);
if (is_null($json)) {
	echo 'Invalid JSON';
	exit;
}

$database = BeaconCommon::Database();
$data = $json['data'];
$type = $json['type'];
$api = new BeaconStripeAPI($api_secret);
switch ($type) {
case 'checkout_beta.session_succeeded':
	$obj = $data['object'];
	$items = $obj['display_items'];
	$purchased_products = array();
	foreach ($items as $item) {
		if ($item['type'] != 'sku') {
			continue;
		}
		
		$sku = $item['sku'];
		
		$results = $database->Query('SELECT product_id, retail_price FROM products WHERE stripe_sku = $1;', $sku);
		if ($results->RecordCount() == 1) {
			$purchased_products[] = array('product_id' => $results->Field('product_id'), 'price' => $results->Field('retail_price'), 'paid' => $item['amount'] / 100);
			continue;
		}
	}
	
	if (count($purchased_products) == 0) {
		http_response_code(200);
		echo 'No products to be handled by this hook';
		exit;
	}
	
	$intent_id = $obj['payment_intent'];
	$client_reference_id = $obj['client_reference_id'];
	$email = $api->EmailForPaymentIntent($intent_id);
	if (is_null($email)) {
		echo 'Unable to find email address for this payment intent';
		exit;
	}
	
	$subtotal = 0;
	$total = 0;
	$line_count = 0;
	$purchase_id = BeaconCommon::GenerateUUID();
	$stw_copies = 0;
	$stw_products = array('f2a99a9e-e27f-42cf-91a8-75a7ef9cf015', '10393874-7927-4f40-be92-e6cf7e6a3a2c');
	$database->BeginTransaction();
	foreach ($purchased_products as $item) {
		$amount = $item['paid'];
		$retail_price = $item['price'];
		$product_id = $item['product_id'];
		
		$subtotal += $retail_price;
		$total += $amount;
		$discount = $retail_price - $amount;
		$line_count++;
		
		if (in_array($product_id, $stw_products)) {
			$stw_copies++;
		}
		
		$database->Query('INSERT INTO purchase_items (purchase_id, product_id, retail_price, discount, line_total) VALUES ($1, $2, $3, $4, $5);', $purchase_id, $product_id, $retail_price, $discount, $amount);
	}
	$database->Query('INSERT INTO purchases (purchase_id, purchaser_email, subtotal, discount, tax, total_paid, merchant_reference, client_reference_id) VALUES ($1, uuid_for_email($2::email, TRUE), $3, $4, $5, $6, $7, $8);', $purchase_id, $email, $subtotal, $subtotal - $total, 0, $total, $intent_id, $client_reference_id);
	
	// Make sure the user's email is removed from the raffle
	$database->Query('DELETE FROM stw_applicants WHERE email_id = uuid_for_email($1);', $email);
	
	// And add more prizes to the raffle
	for ($i = 0; $i < $stw_copies; $i++) {
		$database->Query('INSERT INTO stw_purchases (original_purchase_id) VALUES ($1);', $purchase_id);
	}
	$database->Commit();
	
	http_response_code(200);
	echo 'Purchase redeemed successfully';
	exit;
	
	break;
default:
	http_response_code(200);
	echo 'Unknown hook type. Just assumed this worked, ok?';
	exit;
}

?>