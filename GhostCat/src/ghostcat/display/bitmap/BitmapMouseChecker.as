package ghostcat.display.bitmap
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	import ghostcat.events.TickEvent;
	import ghostcat.util.Tick;
	
	/**
	 * 为位图提供鼠标事件
	 * @author flashyiyi
	 * 
	 */
	public class BitmapMouseChecker
	{
		public var bitmap:Bitmap;
		public var mouseOver:Boolean = false;
		public var mouseDown:Boolean = false;
		
		private var _enabled:Boolean = false;
		
		/**
		 * 是否根据透明度来确认鼠标触发范围
		 */
		public var maskHitArea:Boolean = true;
		
		/**
		 * 鼠标是否在位图上
		 * @return 
		 * 
		 */
		public function isMouseOver():Boolean
		{
			if (!bitmap.bitmapData)
				return false;
			
			if (maskHitArea)
				return uint(bitmap.bitmapData.getPixel32(bitmap.mouseX,bitmap.mouseY) >> 24) > 0;
			else
				return bitmap.bitmapData.rect.contains(bitmap.mouseX,bitmap.mouseY);
		}
		
		public function BitmapMouseChecker(bitmap:Bitmap)
		{
			this.bitmap = bitmap;
			
			enabled = true;
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			if (_enabled == value)
				return;
			
			_enabled = value;
			if (value)
			{
				Tick.instance.addEventListener(TickEvent.TICK,tickHandler);
				bitmap.stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
				bitmap.stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
				bitmap.stage.addEventListener(MouseEvent.CLICK,clickHandler);
			}
			else
			{
				Tick.instance.removeEventListener(TickEvent.TICK,tickHandler);
				bitmap.stage.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
				bitmap.stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
				bitmap.stage.removeEventListener(MouseEvent.CLICK,clickHandler);
			}
		}

		private function tickHandler(event:TickEvent):void
		{
			var o:Boolean = isMouseOver();
			if (mouseOver != o)
			{
				mouseOver = o;
				if (o)
				{
					bitmap.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER,true,false,bitmap.mouseX,bitmap.mouseY))
					bitmap.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER,false,false,bitmap.mouseX,bitmap.mouseY))
				}
				else
				{
					bitmap.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT,true,false,bitmap.mouseX,bitmap.mouseY))
					bitmap.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT,false,false,bitmap.mouseX,bitmap.mouseY))
				}
			}
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			if (event.currentTarget != event.target)
				return;
			
			var o:Boolean = isMouseOver();
			if (o)
			{
				mouseDown = true;
				bitmap.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN,true,false,bitmap.mouseX,bitmap.mouseY,null,event.ctrlKey,event.altKey,event.shiftKey,event.buttonDown))
			}
		}
		
		private function mouseUpHandler(event:MouseEvent):void
		{
			if (event.currentTarget != event.target)
				return;
			
			mouseDown = false;
			var o:Boolean = isMouseOver();
			if (o)
				bitmap.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP,true,false,bitmap.mouseX,bitmap.mouseY,null,event.ctrlKey,event.altKey,event.shiftKey,event.buttonDown))
		}
		
		private function clickHandler(event:MouseEvent):void
		{
			if (event.currentTarget != event.target)
				return;
			
			var o:Boolean = isMouseOver();
			if (o)
				bitmap.dispatchEvent(new MouseEvent(MouseEvent.CLICK,true,false,bitmap.mouseX,bitmap.mouseY,null,event.ctrlKey,event.altKey,event.shiftKey,event.buttonDown))
		}
		
		/**
		 * 销毁事件
		 * 
		 */
		public function destory():void
		{
			enabled = false;
		}
		
	}
}