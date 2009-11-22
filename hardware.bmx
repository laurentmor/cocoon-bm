Type CircuitBoard


EndType

Type Chip


EndType

Type Clockable
	
	
	
	Method ClockActivate()
	
	
	EndMethod
	
EndType


Type RAM
	
	
EndType

Type Line Extends Channel


EndType 



'/* Synchronous Address Multiplexer (SAM) Emulator class */



Type MC6883
	
	Field Qlisteners:Clockable[]
	Field Tlisteners:Clockable[]
	
	

	Method New()
		
		
	EndMethod
	
	Method PowerOn(t:Thread)
		
		
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

Type MC6809 Extends Clockable

	Field programCounter : Short 
	Field registerA : Byte 
	Field registerB : Byte 
	Field registerD : Short 
	Field conditionCode : Byte 
	Field pointerX : Short 
	Field pointerY : Short 
	Field systemStack : Short 
	Field userStack : Short
	Field directPage : Byte
	Field readWrite : Short
    
    ' "implied registers"
	Field currentOpcode : Byte 
	Field currentPostbyte : Byte
 	Field currentAddressMSB : Byte
 	Field currentAddressLSB : Byte
	Field activeByte : Byte
    
    ' utilitary variables
	Field cycleCounter : Int
	Field addressingMode : String
    
    ' Object references TODO: obsolete
        ' initialize
        programCounter = $0000
        registerA = $00
        registerB = $00
        registerD = $0000
        conditionCode = $00
        pointerX = $0000
        pointerY = $0000
        systemStack = $0000
        userStack = $0000
        directPage = $00
        readWrite = False
        
        currentOpcode = $00
        currentPostbyte = $00
        currentAddressMSB = $00
        currentAddressLSB = $00
        activeByte = $00
        
        cycleCounter = 1
        addressingMode = "p"        

    EndMethod

Rem    
    Public void clockActivate()
    {
        Short addressToBeUsed = 0;
        switch (addressingMode)
        {
            Case 'p': //Program Counter
                addressToBeUsed = programCounter;
                break;
                
            Case 'd': //Direct 
                addressToBeUsed = (Short) ((directPage * 256) + currentAddressLSB);
                break;
                
            Case 'x': //Extended
                addressToBeUsed = (Short) ((currentAddressMSB * 256) + currentAddressLSB);
                break;
        }
        
        
        Byte b = memory.accessMemory(readWrite, addressToBeUsed, activeByte);
        this.processByte(b);
    }
    
    protected void processByte(Byte b)
    {
        If (cycleCounter == 1) //first cycle? 
            currentOpcode = b; //Then read opcode!
        
        switch (currentOpcode)
        {
            //*----------------------------------------------
            Case (Byte) $4a:
                //*DECB immediate (2 bytes, 2 cycles)
                switch (cycleCounter)
                {
                    Case 2:
                        registerB--;
                        If (registerB == 0)
                            conditionCode = (Byte) (conditionCode | $04);
                        currentOpcode = $00;
                        cycleCounter = 0;
                        break;
                }
            break;
            

            //*----------------------------------------------
            Case (Byte) $00:
                //*NOP (Not really; actually NEG!)
                currentOpcode = $00;
                cycleCounter = 0;
            break;
            
            //*----------------------------------------------
            Case (Byte) $86:
                //*LDA immediate (2 bytes, 2 cycles)
                switch (cycleCounter)
                {
                    Case 2:
                        registerA = b;
                        currentOpcode = $00;
                        cycleCounter = 0;
                        break;
                }
            break;
            
            //*----------------------------------------------
            Case (Byte) $C6:
                //*LDB immediate (2 bytes, 2 cycles)
                switch (cycleCounter)
                {
                    Case 2:
                        registerB = b;
                        currentOpcode = $00;
                        cycleCounter = 0;
                        break;
                }
            break;
            
           //*----------------------------------------------             
            Case (Byte) $97:
                //*STA direct "base page" (2 bytes, 4 cycles)
                switch (cycleCounter)
                {
                    Case 2:                        
                        currentAddressLSB = b; 
                        break;
                    Case 3:
                        readWrite = True; 
                        addressingMode = 'd';
                        activeByte = registerA;
                        break;
                    Case 4: //Byte written: reset all                        
                        currentOpcode = $00;
                        cycleCounter = 0;
                        currentAddressLSB = $00;
                        currentAddressMSB = $00;
                        readWrite = False;
                        addressingMode = 'p';
                        activeByte = $00;
                        break;
                }
            break;
            
            //*----------------------------------------------
            Case (Byte) $b7:
                //*STA extended "direct" (3 bytes, 5 cycles)
                switch (cycleCounter)
                {
                    Case 2:
                        currentAddressMSB = b; 
                        break;
                    Case 3: 
                        currentAddressLSB = b; 
                        break;
                    Case 4: 
                        readWrite = True;
                        addressingMode = 'x';
                        activeByte = registerA;
                        break;
                    Case 5: //Byte written: reset all
                        currentOpcode = $00;
                        cycleCounter = 0;
                        currentAddressLSB = $00;
                        currentAddressMSB = $00;
                        readWrite = False;
                        addressingMode = 'p';
                        activeByte = $00;
                        break;
                }   
            break;            
        }
        
        cycleCounter++;
        programCounter++;        
        
        
    }
    
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


EndType


Rem

Public class RAM
{
    Byte[] memoryCells;
    
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