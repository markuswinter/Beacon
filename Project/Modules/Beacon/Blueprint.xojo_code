#tag Interface
Protected Interface Blueprint
Implements Beacon.NamedItem
	#tag Method, Flags = &h0
		Function AlternateLabel() As NullableString
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Availability() As UInt64
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Category() As String
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ClassString() As String
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Clone() As Beacon.Blueprint
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsTagged(Tag As String) As Boolean
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ModID() As v4UUID
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ModName() As String
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MutableClone() As Beacon.MutableBlueprint
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ObjectID() As v4UUID
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Path() As String
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Tags() As String()
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToDictionary() As Dictionary
		  
		End Function
	#tag EndMethod


End Interface
#tag EndInterface
