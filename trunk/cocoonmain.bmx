'CoCoon main 

Import "hardware.bmx"
Import "peripherals.bmx"

Global monitor:Display

Init()
MainLoop()
End

Function Init()
	
	SetGraphicsDriver(GLMax2DDriver())
	Graphics 825,625
	
	monitor = Display.Create()

	monitor.TurnOn()

	monitor.Test("test")
		
End Function



Function MainLoop()

	Repeat
	
		Local frame:Int[]
		frame = frame[..147456]
		
		For Local i:Int = 0 To Len(frame)-1
			frame[i] = Rand(0,255)
		Next 
	
	
		monitor.Test("test")
	
		monitor.DisplayFrame(frame, 256, 192)
	
	
	
	Until MouseHit(1)

End Function

End
