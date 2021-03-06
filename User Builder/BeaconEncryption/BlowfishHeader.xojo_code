#tag Class
Private Class BlowfishHeader
	#tag Method, Flags = &h0
		Sub Constructor()
		  Self.mBytes = New Xojo.Core.MutableMemoryBlock(Self.Size)
		  Self.mBytes.LittleEndian = BlowfishLittleEndian
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ConsumeMemoryBlock(Source As Xojo.Core.MemoryBlock)
		  Self.mBytes = New Xojo.Core.MutableMemoryBlock(0)
		  Self.mBytes.LittleEndian = BlowfishLittleEndian
		  Self.mBytes.Append(Source.Left(Min(Source.Size, Self.Size)))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function FromMemoryBlock(Source As Xojo.Core.MemoryBlock) As BlowfishHeader
		  Dim Header As New BlowfishHeader
		  Header.ConsumeMemoryBlock(Source)
		  Return Header
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Convert() As Xojo.Core.MemoryBlock
		  Return New Xojo.Core.MemoryBlock(Self.mBytes)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Operator_Convert(Source As Xojo.Core.MemoryBlock)
		  Self.ConsumeMemoryBlock(Source)
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mBytes.UInt32Value(Self.OffsetChecksum)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Self.mBytes.UInt32Value(Self.OffsetChecksum) = Value
			End Set
		#tag EndSetter
		Checksum As UInt32
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mBytes.UInt32Value(Self.OffsetLength)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Self.mBytes.UInt32Value(Self.OffsetLength) = Value
			End Set
		#tag EndSetter
		Length As UInt32
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mBytes.UInt8Value(Self.OffsetMagicByte)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Self.mBytes.UInt8Value(Self.OffsetMagicByte) = Value
			End Set
		#tag EndSetter
		MagicByte As UInt8
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mBytes As Xojo.Core.MutableMemoryBlock
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mBytes.Mid(Self.OffsetVector, 8)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Self.mBytes.Mid(Self.OffsetVector, 8) = Value
			End Set
		#tag EndSetter
		Vector As Xojo.Core.MemoryBlock
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mBytes.UInt8Value(Self.OffsetVersion)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Self.mBytes.UInt8Value(Self.OffsetVersion) = Value
			End Set
		#tag EndSetter
		Version As UInt8
	#tag EndComputedProperty


	#tag Constant, Name = OffsetChecksum, Type = Double, Dynamic = False, Default = \"14", Scope = Private
	#tag EndConstant

	#tag Constant, Name = OffsetLength, Type = Double, Dynamic = False, Default = \"10", Scope = Private
	#tag EndConstant

	#tag Constant, Name = OffsetMagicByte, Type = Double, Dynamic = False, Default = \"0", Scope = Private
	#tag EndConstant

	#tag Constant, Name = OffsetVector, Type = Double, Dynamic = False, Default = \"2", Scope = Private
	#tag EndConstant

	#tag Constant, Name = OffsetVersion, Type = Double, Dynamic = False, Default = \"1", Scope = Private
	#tag EndConstant

	#tag Constant, Name = Size, Type = Double, Dynamic = False, Default = \"18", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Checksum"
			Group="Behavior"
			Type="UInt32"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Length"
			Group="Behavior"
			Type="UInt32"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MagicByte"
			Group="Behavior"
			Type="UInt8"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Vector"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Version"
			Group="Behavior"
			Type="UInt8"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
