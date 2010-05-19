Strict

Import "hardware.bmx"

Type MC6809E Extends Clockable

	Field cpuAddressBus:Short
	Field cpuDataBus:Byte
	
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
	Field readWrite : Byte
    
    ' "implied registers"
	Field currentOpcode : Byte 
	Field currentPostbyte : Byte
 	Field currentAddressMSB : Byte
 	Field currentAddressLSB : Byte
	Field activeByte : Byte
    
    ' utilitary variables
	Field cycleCounter : Int
	Field addressingMode : String

	Global singleton:MC6809E 
	
	Function Create:MC6809E()
		If singleton = Null Then singleton = New MC6809E
		Return singleton
	End Function

	Method New()
			
		' initialize
		programCounter = $000000
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

	Method ConnectAdressBus(bus:Short)
	
		cpuAddressBus = bus
		
	End Method
	
	Method ConnectDataBus(bus:Byte)
	
		cpuDataBus = bus
		
	End Method
	

	Method clockActivate()
		
		Local addressToBeUsed:Short = 0
		
		Select addressingMode
			
		Case "p" 'Program Counter
                addressToBeUsed = programCounter
                
            Case "d" 'Direct 
                addressToBeUsed = ((directPage * 256) + currentAddressLSB)
                
            Case "x" 'Extended
                addressToBeUsed = ((currentAddressMSB * 256) + currentAddressLSB)
                
		End Select
       
        	'Local b:Byte = memory.accessMemory(readWrite, addressToBeUsed, activeByte)
        	'ProcessByte(b)

	EndMethod
	
	Method ProcessByte(b:Byte)
 	
	Rem       
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

	EndRem

	
	EndMethod



EndType


