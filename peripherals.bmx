Type Display
	
	Global singleton:Display
	Field frequency:Int
	Field screen: TPixmap
	Field VideoIn 'port
	
	
	Method New()
		
		
		
	EndMethod
	
	
	
	Function Create:Display()
		If singleton = Null Then singleton = New Display
		Return singleton
	End Function

	Method TurnOn()
	
		screen = CreatePixmap(525, 525, PF_RGBA8888)
		screen.ClearPixels(0)
		
	End Method
    
	
	Method PowerOn()'thread
		
		
		
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
	
EndType


Type Audio




EndType