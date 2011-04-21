package ghostcat.util.display
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import ghostcat.util.sleep.SleepCheck;

	public final class UIUtil
	{
		static public function packFrameButton(mc:MovieClip,toggle:Boolean = false):void
		{
			var mouseOver:Boolean;
			var mouseDown:Boolean;
			var selected:Boolean;
			
			mc.addEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
			mc.addEventListener(MouseEvent.ROLL_OUT,rollOverHandler);
			mc.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			mc.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			mc.addEventListener(MouseEvent.CLICK,clickHandler);
		
			function mouseUpHandler(event:MouseEvent):void
			{
				mouseDown = true;
				refreshButtonState()
			}
			
			function mouseDownHandler(event:MouseEvent):void
			{
				mouseDown = false;
				refreshButtonState()
			}
			
			function rollOverHandler(event:MouseEvent):void
			{
				mouseOver = true;
				refreshButtonState()
			}
			
			function rollOutHandler(event:MouseEvent):void
			{
				mouseOver = false;
				refreshButtonState()
			}
			
			function clickHandler(event:MouseEvent):void
			{
				if (toggle)
				{
					selected = !selected;
					refreshButtonState()
				}
			}
			
			function refreshButtonState():void
			{
				var offest:int = selected ? 3 : 0;
				if (mouseDown && mouseOver)
				{
					mc.gotoAndStop(3 + offest);
				}
				else
				{
					if (mouseOver)
						mc.gotoAndStop(2 + offest);
					else
						mc.gotoAndStop(1 + offest);
				}
			}
		}
		
	}
}