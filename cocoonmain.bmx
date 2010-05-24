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

	Repeat
	
		sam.PowerIn()
		
	Until MouseHit(1)

End Function

End

Rem 

http://five.pairlist.net/pipermail/coco/2005-January/012346.html

The VDG accesses memory through the SAM chip. The CGD is sy nched to the
SAM chip via the color burst frequency that is derived from the 14.318 MHz crystal
oscillator in the SAM chip. Tha SAM Chip, Synchronous Address Multiplexer,
multiplexes the CPU address, the video address and the refresh count to the dram
chips via the z-buss. The video and MPU memory is shared in ascheme that is
called IDMA, Interleaved Direct Memory Access. This is the main function of the
SAM chip. To control access to the memory by the MPU and the VDG.

All machine cycles start with the falling edge of the E clock. The MPU, MC6809E
reads data into it on the falling edge of the E clock. ON THE RISING EDGE OF THE Q
CLOCK THE MPU ADDRESS IS LATCHED TO THE ADDRESS BUS FOR THE NEXT INSTRUCTION. This is
written to the SAM chip. While the E clock is low, the SAM knows that this is the
VDG portion of the cycle. DUring that porttion the Z-buss has the VDG address on it
and it reads the memory for data to display. When the E clock is high that is the
MPU portion and the address that is written to the SAM chip is then paced on the Z-
buss and either data is read or written to memory depending on the state of the
R/W* line.

The purpose of the Q clock is to provide a second clock internal to the MPU that is
90degrees out of phase from the E clock. For the MPU the Q clock leads the E
clock by 90 degrees. Some of the main timings that are generated with the Q clock
is when the address is valid and when write data is valid. The MPU places the
address of the next memory location on the address on the rising edge of the Q
clock. On the falling edge of the Q clock and if the R/W* line is low then the data
buss is latched with the data to write to that memory location. If the cycle is a read
then the data from memory is latched in on the falling edge of the E clock. 

The VDG has the ability to locate the block of video ram anywhere in the memory
map but must reside on 512 byte boundaries. That is the starting address must be
divisible by 512. This address is set by the seven bits programmed into F0 to F6
registers within the SAM chip. The VDG chip send a signal to the SAM chip to tell it
to decrement/increment the address one byte at a time as needed. The video data
read from memory is passed from ram to the SAM chip to the VDG chip through
transparent latches.

The VDG chip has timing generators that synchronize the display. It has all the
timing generators for the composite sync and proper display on a raster screen. 

------------------------------------------------------------------
http://five.pairlist.net/pipermail/coco/2005-January/012381.html

> * What does the Q-signal do?


In stead of stepping through one state every cycle like many CPUs, the
6809 breaks a single cycle into four states using the combination of
the E and Q clocks to determine which state the CPU is currently in.
This allows the CPU to get more done in a single cycle (it in a way
looks at it as four ticks for one cycle), and makes sharing memory with
another device like the SAM potentially very straightforward. 

I'm not really sure what you're asking. If it is a text screen, the
data read from the computer's memory is translated using the current
row number and the value of the byte read to give a value that is
rotated through a barrel shifter to drive the elements that physically
convert into your actual video signal, for a graphics screen the
translation is a little more direct. At the same time it keeps track
of a horizontal and vertical counter so that it knows when to go into
horizontal and vertical blanking and when to issue horizontal and
vertical sync signals. 

End Rem

