Type Display
	
	Global singleton:Display
	Field frequency:Int
	Field screen: TPixmap
	Field VideoIn 'port
	
	
	Method New()
		
		
		
	End Method
	
	Method Test(test:String)'thread
		
		
	End Method

	Method TurnOn()
	
		screen = CreatePixmap(525, 525, PF_RGBA8888)
		screen.ClearPixels(0)
		
	End Method
    
	
	

	Method DisplayFrame(frame:Int[], hsync:Int, vsync:Int)
	
		Local i:Int = 0
		
		For y=1 To vsync	
		
			For x=1 To hsync

				'SetPixel(x, y, frame[i])
				
				SetColor(frame[i], frame[i+1], frame[i+2])
				DrawLine(x, y, x+1, y+1)
				
				i = i + 3
			Next 
			i = i + 3
		Next 
	
	
	End Method
	
	Function Create:Display()
		If singleton = Null Then singleton = New Display
		Return singleton
	End Function

	
EndType


Type Audio




EndType