package ghostcat.util.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import ghostcat.events.TickEvent;
	import ghostcat.util.Tick;

	/**
	 * 位图动画类
	 * @author flashyiyi
	 * 
	 */
	public final class BitmapMovieUtil
	{
		/**
		 * 创建一个ENTER_FRAME驱动的位图动画，返回值为停止动画的函数。这个动画在任何时候都能保持均匀速率。
		 * @param bitmap
		 * @param bitmapDatas
		 * @param frameRate
		 * @return 
		 * 
		 */
		static public function createMovieTicker(bitmap:Bitmap,bitmapDatas:Array,frameRate:int = 30):Function
		{
			var currentFrame:int = 0;
			var frameTimer:int = 0;
			bitmap.bitmapData = bitmapDatas[0];
			
			Tick.instance.addEventListener(TickEvent.TICK,tickHandler);
			
			function tickHandler(event:TickEvent):void
			{
				frameTimer -= event.interval;
				while (frameTimer < 0) 
				{
					if (currentFrame == bitmapDatas.length - 1)
						currentFrame = 0;
					else
						currentFrame++;
					
					bitmap.bitmapData = bitmapDatas[currentFrame];
					
					frameTimer += 1000 / frameRate;
				}
			}
			
			function endHandler():void
			{
				Tick.instance.removeEventListener(TickEvent.TICK,tickHandler);
			}
			
			return endHandler;
		}
		
		/**
		 * 创建一个Timer驱动的位图动画，返回值为Timer对象 
		 * @param bitmap
		 * @param bitmapDatas
		 * @param frameRate
		 * @return 
		 * 
		 */
		static public function createMovieTimer(bitmap:Bitmap,bitmapDatas:Array,frameRate:int = 30):Timer
		{
			var currentFrame:int = 0;
			bitmap.bitmapData = bitmapDatas[0];
			
			var timer:Timer = new Timer(1000 / frameRate,uint.MAX_VALUE);
			timer.addEventListener(TimerEvent.TIMER,tickHandler);
			timer.start();
			
			function tickHandler(event:TimerEvent):void
			{
				if (currentFrame == bitmapDatas.length - 1)
					currentFrame = 0;
				else
					currentFrame++;
					
				bitmap.bitmapData = bitmapDatas[currentFrame];
			}
			
			return timer;
		}
		
		/**
		 * 将动画缓存成位图序列
		 * @see ghostcat.display.movieclip.MovieClipCacher
		 *  
		 * @param mc
		 * @param rect
		 * @param start
		 * @param len
		 * @return 
		 * 
		 */
		static public function cacheMovieToBitmapDatas(mc:MovieClip,rect:Rectangle=null,start:int = 1,len:int = -1):Array
		{
			var endFrame:int;
			if (len == -1)
			{
				endFrame = mc.totalFrames;
			}
			else
			{
				endFrame = start + len - 1;
				if (endFrame > mc.totalFrames)
					endFrame = mc.totalFrames;
			}
			
			rect = rect ? rect : mc.getBounds(mc)
			
			var result:Array = [];
			while (true)
			{
				var bitmapData:BitmapData = new BitmapData(Math.ceil(rect.width),Math.ceil(rect.height),true,0);
				var m:Matrix;
				if (rect)
				{
					m = new Matrix();
					m.translate(-rect.x,-rect.y);
				}
				bitmapData.draw(mc,m);
				result.push(bitmapData);
				
				if (mc.currentFrame >= endFrame)
					return result;
				else
					mc.nextFrame();
			}
			return null;
		}
	}
}