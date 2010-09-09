package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	/**
	 * 这个类提供了FPS监控功能，可以用作性能优化的标准
	 * 
	 * @author flashyiyi
	 */	
	public class FPS extends Sprite
	{
		/**
		 * 采样次数
		 */		
		public var sampling:int = 30;
		
		/**
		 * 默认帧频，为0时则取舞台帧频
		 */		
		public var frameRate:int = 0;
		
		private var fpsTextField:TextField;
		private var bitmap:Bitmap;
		private var intervalArr:Array=[];
		
		public var t:int = getTimer();
		
		public function FPS()
		{
			super();
			
			mouseEnabled = mouseChildren = false;
        	
			fpsTextField = new TextField();
			fpsTextField.defaultTextFormat = new TextFormat(null,null,0xFF0000);
			fpsTextField.width = 60;
			fpsTextField.height = 16;
			fpsTextField.selectable = false;
			addChild(fpsTextField);
			
			bitmap = new Bitmap(new BitmapData(20,20,true,0x00FFFFFF));
			bitmap.x = 60;
			addChild(bitmap);
			
			this.addEventListener(Event.ENTER_FRAME,tickHandler);
		}
		
		
		
		private function tickHandler(event:Event):void
		{
			if (stage==null) 
				return;
			
			var cur:int = getTimer();
			var interval:int = cur - t;
			t = cur;
			
			intervalArr.push(interval);
			
			if (intervalArr.length == sampling)
			{
				var intervalSun:int = 0;
				for (var i:int=0; i < intervalArr.length;i++)
				{
					intervalSun += intervalArr[i];
				}
				var fps:Number = 1000 / (intervalSun / intervalArr.length);
				intervalArr = [];
				
				fpsTextField.text = " FPS: " + fps.toFixed(2);
				
				bitmap.bitmapData.scroll(-1,0);
				
				var _frameRate:int = (frameRate>0)?frameRate:stage.frameRate;
				
				for (i=0; i< 20;i++)
				{
					if (i == Math.round(20 * (1 - fps/(_frameRate*2))))
					{
						bitmap.bitmapData.setPixel32(19,i,0xFFFF0000);
					}
					else
					{
						bitmap.bitmapData.setPixel32(19,i,0x00000000);
					}
				}
			}
		}
	}
}