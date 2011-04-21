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
	import flash.utils.getTimer;
	
	[Event(name="complete",type="flash.events.Event")]
	
	/**
	 * 将电影剪辑缓存为位图数组的类，可以将其转移到GBitmapMovieClip进行播放
	 * 缓存需要时间，需要监听complete事件，也可以调用renderAllFrames方法立即完成缓存
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
		 * 每次缓存允许的最高时间
		 */
		public var limitTimeInFrame:int;
		
		private var _startFrame:int;//开始读取的帧
		private var _readFrame:int;//预计要读取的帧
		private var _endFrame:int;//最后一帧的位置
		private var readWhenPlaying:Boolean;//是否在播放时缓存
		private var _readComplete:Boolean = false;
		private var timer:Timer;
		
		/**
		 * 是否已经绘制完成
		 */
		public function get readComplete():Boolean
		{
			return _readComplete;
		}
		
		/**
		 * 目前读取的帧
		 */
		public function get readFrame():int
		{
			return _readFrame;
		}
		
		/**
		 * 读取起始帧
		 */
		public function get startFrame():int
		{
			return _startFrame;
		}
		
		/**
		 * 读取结束帧
		 */
		public function get endFrame():int
		{
			return _endFrame;
		}
		
		/**
		 * 缓存动画
		 *  
		 * @param mc		要缓存的动画
		 * @param rect		绘制范围
		 * @param start		起始帧
		 * @param len		长度
		 * @param readWhenPlaying	是否在播放时顺便缓存
		 * @param limitTimeInFrame	每次缓存允许的最高时间
		 */
		public function MovieClipCacher(mc:MovieClip,rect:Rectangle=null,start:int = 1,len:int = -1,readWhenPlaying:Boolean = false,limitTimeInFrame:int = 10)
		{
			this.mc = mc;
			this.readWhenPlaying = readWhenPlaying;
			this.limitTimeInFrame = limitTimeInFrame;
			
			this.rect = rect ? rect : mc.getBounds(mc)
			
			this._startFrame = start;
			this._readFrame = start;
			mc.gotoAndStop(start);
			
			if (len == -1)
			{
				this._endFrame = mc.totalFrames;
			}
			else
			{
				this._endFrame = start + len - 1;
				if (this._endFrame > mc.totalFrames)
					this._endFrame = mc.totalFrames;
			}
			
			this.result = [];
			this._readComplete = false;
			
			if (readWhenPlaying)
			{
				this.mc.addEventListener(Event.ENTER_FRAME,timeHandler);	
			}
			else
			{
				this.timer = new Timer(0,int.MAX_VALUE);
				this.timer.addEventListener(TimerEvent.TIMER,timeHandler);
				this.timer.start();
			}
		}
		
		
		/**
		 * 立即渲染完所有帧
		 * 
		 */
		public function renderAllFrames():void
		{
			this.limitTimeInFrame = int.MAX_VALUE;
			timeHandler(null);
		}
		
		private function timeHandler(event:Event):void
		{
			var t:int = getTimer();
			do
			{
				if (readWhenPlaying || mc.currentFrame >= _readFrame)
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
					
					if (mc.currentFrame >= _endFrame)
					{
						readCompleteHandler();
						break;
					}
					else
					{
						_readFrame++;
						if (!readWhenPlaying)//播放时缓存不控制动画
							mc.nextFrame();
					}
				}
			}
			while (!readWhenPlaying && getTimer() - t < limitTimeInFrame)
		}
		
		private function readCompleteHandler():void
		{
			if (readWhenPlaying)
			{
				this.mc.removeEventListener(Event.ENTER_FRAME,timeHandler);	
			}
			else
			{
				this.timer.removeEventListener(TimerEvent.TIMER,timeHandler);
				this.timer.stop();
				this.timer = null;
			}
			
			this._readComplete = true;
			
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