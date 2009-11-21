Type Display
	
	Field VideoIn
	
	Method New()
		
		
	EndMethod
	
	Method DisplayFrame(frame:Int[], hsync:Int, vsync:Int)
	
		Local i:Int = 0
		
		For y=1 To vsync	
		
			For x=1 To hsync
				
				'SetPixel(x, y, frame[i])
				
				i = i + 1
			Next 
			i = i + 1
		Next 
	
	
	EndMethod
	
	Method PowerOn()'thread
		
		
		
	EndMethod
	
EndType


Type Audio




EndType