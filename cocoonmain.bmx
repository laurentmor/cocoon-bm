'CoCoon main 

Import "hardware.bmx"
Import "peripherals.bmx"

Global monitor:Display

Init()
MainLoop()
End

Function Init()
	
	SetGraphicsDriver(GLMax2DDriver())
	Graphics 296,232
	
	monitor = Display.Create()

	monitor.TurnOn()
	
	vidRam:Short = $4000
	Print vidRam	
	
End Function



Function MainLoop()

	Repeat
	
		Local frame:Int[]
		frame = frame[..147456]
		
		For Local i:Int = 0 To Len(frame)-1
			frame[i] = Rand(0,255)
		Next 
		
		monitor.DisplayFrame(frame, 256, 192)
		
		Rem
		For Local j:Int = 0 To 192
			
			Local line:Int[] 
			line = line[..256*3]
			
			For Local h:Int = j*0 To j*255
				Print j*h
				line[h] = frame[j*h]
				
			Next
			
			monitor.DisplayLine(line, 256, j)
		
		Next
		EndRem
		
	Until MouseHit(1)

End Function

End
