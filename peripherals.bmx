Type Display
	
	Global singleton:Display
	Field frequency:Int
	Field screen: TPixmap
	Field scale:Int
	Field VideoIn 'port
	
	
	Method New()
		
		
		
	End Method
	
	Method TurnOn()
	
		screen = CreatePixmap(525, 525, PF_RGBA8888)
		screen.ClearPixels(0)
		
		scale = 1
		
	End Method
    
	
	

	Method DisplayFrame(frame:Int[], hsync:Int, vsync:Int)
	
		Local i:Int = 0
		
		For y=40 To vsync	
		
			For x=40 To hsync

				'SetPixel(x, y, frame[i])
				
				If i+3 < 147456
				
					SetColor(frame[i], frame[i+1], frame[i+2])
					DrawRect(x, y, 1, 1)
					
				End If
				
				i = i + 3
			Next 
			i = i + 3
		Next 
	
		Flip()
				
	End Method
	
	Function Create:Display()
		If singleton = Null Then singleton = New Display
		Return singleton
	End Function

	
EndType


Type Audio




EndType