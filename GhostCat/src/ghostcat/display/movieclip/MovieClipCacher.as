package ghostcat.display.movieclip
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	[Event(name="complete",type="flash.events.Event")]
	
	/**
	 * 将电影剪辑缓存为位图数组的类，可以将其转移到GBitmapMovieClip进行播放
	 * 
	 * @see ghostcat.display.movieclip.GBitmapMovieClip
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class MovieClipCacher extends EventDispatcher
	{
		/**
		 * 要缓存的动画
		 */
		public var mc:MovieClip;
		
		/**
		 * 绘制范围
		 */		
		public var rect:Rectangle;
		
		/**
		 * 生成的位图数组
		 */
		public var result:Array;
		
		/**
		 * 是否已经绘制完成
		 */
		public var readComplete:Boolean=false;
		
		private var readFrame:int;//预计要读取的帧
		private var endFrame:int;//最后一帧的位置
		private var timer:Timer;
		
		public function MovieClipCacher(mc:MovieClip,rect:Rectangle=null,start:int = 1,len:int = -1)
		{
			if (mc)
				read(mc,rect,start,len);
		}
		
		/**
		 * 缓存动画
		 *  
		 * @param mc		要缓存的动画
		 * @param rect		绘制范围
		 * @param start		起始帧
		 * @param len		长度
		 * 
		 */
		public function read(mc:MovieClip,rect:Rectangle=null,start:int = 1,len:int = -1):void
		{
			this.mc = mc;
			
			this.rect = rect ? rect : mc.getBounds(mc)
			
			this.readFrame = start;
			mc.gotoAndStop(start);
			
			if (len == -1)
			{
				this.endFrame = mc.totalFrames;
			}
			else
			{
				this.endFrame = start + len - 1;
				if (this.endFrame > mc.totalFrames)
					this.endFrame = mc.totalFrames;
			}
			
			this.result = [];
			this.readComplete = false;
			
			this.timer = new Timer(0,int.MAX_VALUE);
			this.timer.addEventListener(TimerEvent.TIMER,timeHandler);
			this.timer.start();
		}
		
		private function timeHandler(event:Event):void
		{
			if (mc.currentFrame >= readFrame)
			{
				var bitmapData:BitmapData = new BitmapData(rect.width,rect.height,true,0);
				var m:Matrix;
				if (rect)
				{
					m = new Matrix();
					m.translate(-rect.x,-rect.y);
				}
				bitmapData.draw(mc,m);
				result.push(bitmapData);
				
				if (mc.currentFrame >= endFrame)
					readCompleteHandler();
				else
				{
					readFrame++;
					mc.nextFrame();
				}
			}
		}
		
		private function readCompleteHandler():void
		{
			this.timer.removeEventListener(TimerEvent.TIMER,timeHandler);
			this.timer.stop();
			this.timer = null;
			
			this.readComplete = true;
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
        /**
         * 回收位图资源 
         * 
         */
        public function dispose():void
        {
        	for each (var bitmapData:BitmapData in result.length)
        		bitmapData.dispose();
        }
	}
}