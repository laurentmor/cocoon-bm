SuperStrict 

Import "hardware.bmx"
Import "CPU.bmx"
Import "peripherals.bmx"

Global monitor:Display
Global memory:RAM
Global SAM:MC6883 
Global vdg:MC6847
Global cpu:MC6809E 

Init()
MainLoop()
End

Function Init()
	
	SetGraphicsDriver(GLMax2DDriver())
	Graphics 296,232
	
	'get singleton instances of main hardware components
	memory = RAM.Create()
	sam = MC6883.Create()
	vdg = MC6847.Create()
	'vdg.ConnectMemory(memory)
	cpu = MC6809E.Create()
	cpu.ConnectMemory(memory)
	
	'connect clockables to multiplexer
	sam.AddQlistener(cpu)
	sam.AddTlistener(vdg)
	
	'set up display
	monitor = Display.Create()
	monitor.TurnOn()
	
End Function

Function MainLoop()

	Repeat
	
		sam.PowerIn()
		
	Until MouseHit(1)

End Function

End
