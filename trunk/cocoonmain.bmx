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
Global readWrite:Byte

Init()
MainLoop()
End

Function Init()
	
	Print "Initializing..."
	
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
	
	Print "connecting components to multiplexer"
	'connect clockables to multiplexer
	sam.AddRuler(cpu)
	sam.AddSucker(vdg)
	sam.ConnectMemory(memory)
	readWrite = $00

	'set up display
	monitor = Display.Create()
	monitor.TurnOn()
	
End Function

Function MainLoop()
	
	Local time:Int  = MilliSecs()
	
	Repeat
	
		sam.PowerIn()
		
	Until MouseHit(1)

	Local timePassed:Int = (MilliSecs() - time)
	
	Local freq:Double = (CPU.programCounter / timePassed)
	
	Print 
	Print "time passed: " + timePassed + " ms"
	Print 
	Print "CPU frequency: " + freq + " KHz" 

End Function

End

