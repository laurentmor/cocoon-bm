SuperStrict

Type Clockable
'Superclass for components that can be hooked up to multiplexer

	Method ClockAddressBus()
	
	End Method
		
	Method ClockDataBus()
	
	End Method
	
EndType

Type Configurable Extends Clockable
'Superclass for clockable components that can be configured through memory addresses

	Method SetRegister()
		
		
		
	End Method

End Type 

