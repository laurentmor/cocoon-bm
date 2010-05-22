SuperStrict

Import "common.bmx"

Type MC6883 Extends Configurable 
'Synchronous Address Multiplexer (SAM) emulation class
	
	Global singleton:MC6883
	Field Suckers:Clockable[]
	Field Rulers:Clockable[]
	Field samAddressBus:Short
	Field extAddressBus:Short
	Field E:Byte
	Field Q:Byte
	
	Method New()
	
		Print "setting up SAM"	
	
		Suckers = New Clockable[1]
		Rulers = New Clockable[1]
		
		E = $00
		Q = $ff
		
	End Method
	
	Function Create:MC6883()
		If singleton = Null Then singleton = New MC6883
		Return singleton
	End Function

	Method AddSucker(q:Clockable)
	
		Suckers[0] = q
		
	End Method
	
	Method AddRuler(e:Clockable)
	
		Rulers[0] = e
		
	End Method
	
	Method ConnectAdressBus(bus:Short)
	
		samAddressBus = bus
		
	End Method
	
	Method ConnectExtAddressBus(bus:Short)
	
		extAddressBus = bus
		
	End Method
	
	Method PowerIn()
				
		'Clock cycle
		
		If E = $00 And Q = $00
		
			For Local q:Clockable = EachIn Suckers 
			
				'TODO: set address bus
				
			Next
			
			Q = $ff
	
		End If
		
		If E= $00 And Q = $ff
		
			For Local q:Clockable = EachIn Suckers 
			
				'TODO: enable data fetch
				
			Next
			
			E = $ff
		
		End If
		
		If E = $ff And Q = $ff	
		
			For Local e:Clockable = EachIn Rulers 
				
				'TODO: enable set address bus
				
			Next
			
			Q = $00
		
		End If
		
		If E = $ff And Q = $00
		
			For Local e:Clockable = EachIn Rulers 
				
				'TODO: enable data fetch
				
			Next
			
			Q = $ff
		
		End If
		
		'TODO: wait (time span depending on clocking speed) - time passed (unless result < 0)
		
		'TODO: reset time passed variable
		
	EndMethod
	
	Method RefreshMemory() 	
		
		
		
	End Method

EndType

Type MC6847 Extends Configurable 
'Video Display Generator (VDG) emulation class

	Global singleton:MC6847 
	Field addressCounter:Short
	Field vdgAddressBus:Short
	Field vdgDataBus:Byte
	
	Function Create:MC6847()
		If singleton = Null Then singleton = New MC6847 
		Return singleton
	End Function

	Method New()
	
		Print "setting up VDG"	
	
	End Method
	
	Method ConnectAdressBus(bus:Short)
	
		vdgAddressBus = bus
		
	End Method
	
	Method ConnectDataBus(bus:Byte)
	
		vdgDataBus = bus
		
	End Method
	
	Method ClockDataFetch()
	
		'TODO: read data bus		
		
		'ProcessByte(getByte)
		
	End Method
	
	Method ProcessByte(b:Byte)
	 
		'TODO check screen mode (memory addresse $FF22)
		
		'TODO do processing
		
		'SNIPPET
		Rem
	
		Local frame:Int[]
		frame = frame[..147456]
		
		
		For Local i:Int = 0 To Len(frame)-1
			'frame[i] = Rand(0,255)
			
			frame[i] = memory.accessMemory(False, i + $4000, Null)
			'Print frame[i]
		Next 
		
		monitor.DisplayFrame(frame, 256, 192)
		
		'Rem
		For Local j:Int = 0 To 192
			
			Local line:Int[] 
			line = line[..256*3]
			
			For Local h:Int = j*0 To j*255
				Print j*h
				line[h] = frame[j*h]
				
			Next
			
			monitor.DisplayLine(line, 256, j)
		
		Next
		'End Rem
	
		End Rem
		
	End Method
	
End Type    

Type MemoryElement

	Field Value:Byte
	Field configurables:TList

	Method New()
	
		configurables = CreateList()
		
	End Method
	
	Method GetByte:Byte()
	
		Return Value
	
	End Method
	
	Method SetByte(value:Byte)
		
		Value = value
		
	End Method
	
	Method AddConfigurable(c:Configurable)
	
		configurables.AddLast(c)
	
	End Method

End Type

Type RAM
	
	Global singleton:RAM
	
	Field ramAddressBus:Short
	Field ramDataBus:Byte
	Field memoryElements:MemoryElement[]
	
	Method New()
		
		Print "Initializing RAM memory."
		
		memoryElements = New MemoryElement[65536]
		
		For Local i:Int = 0 To memoryElements .length - 1
		
			memoryElements[i] = New MemoryElement
			memoryElements[i].SetByte($00)

					
		Next
	
		'simple test program
	      memoryElements[0].SetByte($86) 'LDA
	      memoryElements[1].SetByte($88) '$FF
	      memoryElements[2].SetByte($b7) 'STA
	      memoryElements[3].SetByte($40) 'MSB
	      memoryElements[4].SetByte($00) 'LSB
		
		'simple test graphics
		Local vidRam:Short = $4000
		For Local k:Int = vidRam  To vidRam + $2000 Step 3
			memoryElements[k+0].SetByte($ff)
			memoryElements[k+1].SetByte($00)
			memoryElements[k+2].SetByte($ff)
		Next
		
		
	End Method
	
	Function Create:RAM()
		If singleton = Null Then singleton = New RAM
		Return singleton
	End Function
	
	Method ConnectAdressBus(bus:Short)
	
		ramAddressBus = bus
		
	End Method
	
	Method ConnectDataBus(bus:Byte)
	
		ramDataBus = bus
		
	End Method
	
	Method accessMemory:Byte (readWrite:Byte, addressToBeUsed:Short, activeByte:Byte)
		
		If readWrite
			
			 memoryElements[addressToBeUsed].SetByte(activeByte)
			
		Else
			
			Return memoryElements[addressToBeUsed].GetByte()
			
		End If 
		
	EndMethod
	
	Method readMemory:Byte(memoryAddress:Short)
    
		Return memoryElements[memoryAddress].GetByte()

	End Method
    
	Method writeMemory(memoryAddress:Short, memoryByte:Byte)

      	memoryElements[memoryAddress].SetByte(memoryByte)
	
	End Method
	
	
	
EndType

