'CoCoon main 

Import "hardware.bmx"
Import "peripherals.bmx"

Init()
MainLoop()
End

Function Init()
	
	SetGraphicsDriver(GLMax2DDriver())
	Graphics 825,625
	
	Local monitor:Display = Display.Create()

	monitor.TurnOn()


End Function



Function MainLoop()

	Repeat
	
	
	
	
	
	Until MouseHit(1)

EndFunction

End
