Type Clockable
'Superclass for components that can be hooked up to multiplexer
	
	Method ClockActivate()
	
	End Method
	
EndType

Type Configurable Extends Clockable
'Superclass for clockable components that can be configured through memory addresses

	Method SetRegister()
		
		
		
	End Method

End Type 

Type MC6883 Extends Configurable 
'Synchronous Address Multiplexer (SAM) emulation class
	
	Global singleton:MC6883
	Field Qlisteners:Clockable[]
	Field Tlisteners:Clockable[]
	
	Method New()
		
		Qlisteners = New Clockable[1]
		Tlisteners = New Clockable[1]
		
	End Method
	
	Function Create:MC6883()
		If singleton = Null Then singleton = New MC6883
		Return singleton
	End Function

	Method AddQlistener(q:Clockable)
	
		Qlisteners[0] = q
		
	End Method
	
	Method AddTlistener(t:Clockable)
	
		Tlisteners[0] = t
		
	End Method
	
	
	Method PowerIn()
	
		For Local q:Clockable = EachIn Qlisteners 
			
			q.ClockActivate()
			
		Next
		
		'TODO: wait (time span depending on clocking speed)
		
		For Local t:Clockable = EachIn Tlisteners 
			
			t.ClockActivate()
			
		Next
		
	EndMethod

EndType

Type MC6847 Extends Configurable 
'Video Display Generator (VDG) emulation class

	Global singleton:MC6847 
	'Field memory:RAM
	
	Function Create:MC6847()
		If singleton = Null Then singleton = New MC6847 
		Return singleton
	End Function

	Method New()
		
	End Method
	
	Method ConnectMemory(mem:RAM)
	
		memory = mem
		
	End Method
	
	Method ClockActivate()
	
		Print"VDG activated!"
		'TODO accessmemory
		
		'TODO processbyte
	
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
	
	'Field memoryCells:Byte[] 
	Field memoryElements:MemoryElement[]
	
	Method New()
		
		Print "Initializing RAM memory."
		
		'memoryCells = New Byte[65536]
		memoryElements = New MemoryElement[65536]
		
		For Local i:Int = 0 To memoryElements .length - 1
		
			'memoryCells[i] = 0
			memoryElements[i] = New MemoryElement
			memoryElements[i].SetByte($00)

					
		Next
	
		Rem
		'simple test program
	      memoryCells[0] = $86 'LDA
	      memoryCells[1] = $88 '$FF
	      memoryCells[2] = $b7 'STA
	      memoryCells[3] = $40 'MSB
	      memoryCells[4] = $00 'LSB
		End Rem
		
		'simple test program
	      memoryElements[0].SetByte($86) 'LDA
	      memoryElements[1].SetByte($88) '$FF
	      memoryElements[2].SetByte($b7) 'STA
	      memoryElements[3].SetByte($40) 'MSB
	      memoryElements[4].SetByte($00) 'LSB
		
		Rem 
		'simple test graphics
		vidRam:Short = $4000
		For Local j:Int = vidRam  To vidRam + $2000 Step 3
			memoryCells[j+0] = $ff
			memoryCells[j+1] = $ff
			memoryCells[j+2] = $ff
		Next
		End Rem
	
		'simple test graphics
		vidRam:Short = $4000
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
	
	Method accessMemory:Byte (readWrite:Byte, addressToBeUsed:Short, activeByte:Byte)
		
		If readWrite
			
			 memoryElements[addressToBeUsed].SetByte(activeByte)
			
		Else
			
			Return memoryElements[addressToBeUsed].GetByte()
			
		End If 
		
	EndMethod
	
	Method readMemory(memoryAddress:Short)
    
		Return memoryElements[memoryAddress].GetByte()

	End Method
    
	Method writeMemory(memoryAddress:Short, memoryByte:Byte)

      	memoryElements[addressToBeUsed].SetByte(memoryByte)
	
	End Method
	
EndType

