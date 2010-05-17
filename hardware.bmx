Type Clockable
	
	Method ClockActivate()
	
	End Method
	
EndType


'/* Synchronous Address Multiplexer (SAM) Emulator class */

Type MC6883
	
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
	
	
	Method PowerOn()'t:Thread
		
		Repeat
	
			For Local q:Clockable = EachIn Qlisteners 
				
				q.ClockActivate()
				
			Next
			
			'TODO: wait (depending on clocking speed)
			
			For Local t:Clockable = EachIn Tlisteners 
				
				t.ClockActivate()
				
			Next
		
		Until MouseHit(1)
		
	EndMethod
	
Rem	    
    Public void powerOn()
    {
        For (Int i=0;i<10;i++)
        {
            CPU.clockActivate();                        
            VDG.clockActivate();
        }
        
        //*temporary debug routine
        Byte b = Memory.memoryCells[16384];
        System.err.println("16384: " + b);
                
    }
}
EndRem

EndType

Type MC6847 Extends Clockable

	Global singleton:MC6847 
	Field memory:RAM
	
	Method New(mem:RAM)
	
		'memory = mem 'TODO: error 
		
	End Method
	
	Method ClockActivate()
	
		'TODO accessmemory
		
		'TODO processbyte
	
	End Method
	
	Method ProcessByte(b:Byte)
	
		'TODO check screen mode (memory addresse $FF22)
		
		'TODO do processing
	
	End Method
	
End Type    


Rem 
Public class MC6847
{
    RAM Memory;
    
    Public MC6847(RAM mem)
    {
        Memory = mem;    
    }
    
    Public void clockActivate()
    {
        //accessMemory
        
        //processByte(Byte)
    }
    
    protected void processByte(Byte Byte)
    {
        
    }
    
    
}
EndRem

Type RAM
	
	Global singleton:RAM
	
	Field memoryCells:Byte[] 
		
	Method New()
		
		Print "Initializing RAM memory."
		
		memoryCells = New Byte[65536]
		
		For Local i:Int = 0 To memoryCells.length - 1
		
			memoryCells[i] = 0
		
		Next
	
		'simple test program
	      memoryCells[0] = $86 'LDA
	      memoryCells[1] = $88 '$FF
	      memoryCells[2] = $b7 'STA
	      memoryCells[3] = $40 'MSB
	      memoryCells[4] = $00 'LSB
		
		'simple test graphics
		vidRam:Short = $4000
		           
		For Local j:Int = vidRam  To vidRam + $2000 Step 3
			
			memoryCells[j+0] = $ff
			memoryCells[j+1] = $ff
			memoryCells[j+2] = $ff
			
		Next
	
	End Method
	
	Function Create:RAM()
		If singleton = Null Then singleton = New RAM
		Return singleton
	End Function
	
	Method accessMemory:Byte (readWrite:Byte, addressToBeUsed:Short, activeByte:Byte)
		
		If readWrite
			
			memoryCells[addressToBeUsed] = activeByte
			
		Else
			
			Return memoryCells[addressToBeUsed]
			
		End If 
		
	EndMethod
	
EndType


Rem
    Public RAM()
    {
        memoryCells = New Byte[65536];
        For(Int i=0;i<memoryCells.length;i++)
            memoryCells[i] = 0;
        
        //*simple test program
        memoryCells[0] = (Byte) $86; //LDA
        memoryCells[1] = (Byte) $88; //$FF
        memoryCells[2] = (Byte) $b7; //STA
        memoryCells[3] = (Byte) $40; //MSB
        memoryCells[4] = (Byte) $00; //LSB
        
        //*temporary debug routine
        For (Int i=0;i<5;i++)
            System.err.Print("" + memoryCells[i] + "|");
        System.err.println();
        
        If(memoryCells[0] == (Byte) $86)
            System.err.println("byte recognized as hexadecimal!");
        Else
            If(memoryCells[0] == -122)
                System.err.println("byte recognized as decimal!");        
    }
    
    Public Byte accessMemory(boolean readWrite, Short memoryAddress, Byte memoryByte)
    {
        Byte returnByte = 0;
        
        If (readWrite)
        {
            System.err.println("write " + memoryByte + " to " + memoryAddress);
            memoryCells[memoryAddress] = memoryByte;
            returnByte = 0;
        }
        Else
        {
            returnByte = memoryCells[memoryAddress];
            System.err.println("read " + returnByte + " from " + memoryAddress);            
        }
                
        Return returnByte;
    }
    
    Public Byte readMemory(Short memoryAddress)
    {
        Return memoryCells[memoryAddress];
    }
    
    Public void writeMemory(Short memoryAddress, Byte memoryByte)
    {
        memoryCells[memoryAddress] = memoryByte;
    }
    
}
EndRem
