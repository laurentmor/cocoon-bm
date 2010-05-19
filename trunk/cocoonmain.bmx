SuperStrict 

Import "hardware.bmx"
Import "CPU.bmx"
Import "peripherals.bmx"

Global monitor:Display
Global memory:RAM
Global SAM:MC6883 
Global vdg:MC6847
Global cpu:MC6809E 
Global addressBus:Short
Global dataBus:Byte

Init()
MainLoop()
End

Function Init()
	
	SetGraphicsDriver(GLMax2DDriver())
	Graphics 296,232
	
	memory = RAM.Create()
	memory.ConnectAdressBus(addressBus)
	memory.ConnectDataBus(dataBus)
	
	sam = MC6883.Create()
	sam.ConnectAdressBus(addressBus)
	
	vdg = MC6847.Create()
	vdg.ConnectAdressBus(sam.extAddressBus)
	vdg.ConnectDataBus(dataBus)
	
	cpu = MC6809E.Create()
	cpu.ConnectAdressBus(addressBus)
	cpu.ConnectDataBus(dataBus)
	
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
