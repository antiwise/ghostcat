package ghostcat.util.easing
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	[Event(name="complete",type="flash.events.Event")]
	
	/**
	 * 缓存Tween的结果为位图序列
	 * @author flashyiyi
	 * 
	 */
	public class TweenCacher extends EventDispatcher
	{
		/**
		 * 目标
		 */
		public var target:DisplayObject;
		
		/**
		 * 播放时的帧频
		 */
		public var frameRate:Number;
		
		/**
		 * Tween对象
		 */
		public var tween:TweenUtil;
		
		/**
		 * 绘制范围
		 */		
		public var rect:Rectangle;
		
		/**
		 * 生成的位图数组
		 */
		public var result:Array;
		
		private var _readComplete:Boolean = false;
		
		private var timer:Timer;
		private var canvas:Sprite;
		private var limitTimeInFrame:int;//每帧限时
		
		/**
		 * 是否已经绘制完成
		 */
		public function get readComplete():Boolean
		{
			return _readComplete;
		}
		
		public function TweenCacher(target:DisplayObject,duration:Number,params:Object,frameRate:Number,rect:Rectangle=null,limitTimeInFrame:int = 10)
		{
			this.target = target;
			this.frameRate = frameRate;
			this.limitTimeInFrame = limitTimeInFrame;
			
			this.canvas = new Sprite();
			this.canvas.addChild(target);
			
			this.rect = rect ? rect : canvas.getBounds(canvas);
			this.tween = new TweenUtil(target,duration,params,false);
			
			this.result = [];
			this._readComplete = false;
			
			this.timer = new Timer(0,int.MAX_VALUE);
			this.timer.addEventListener(TimerEvent.TIMER,timeHandler);
			this.timer.start();
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
				if (tween.currentTime < tween.duration)
				{
					var bitmapData:BitmapData = new BitmapData(Math.ceil(rect.width),Math.ceil(rect.height),true,0);
					var m:Matrix;
					if (rect)
					{
						m = new Matrix();
						m.translate(-rect.x,-rect.y);
					}
					bitmapData.draw(canvas,m);
					result.push(bitmapData);
					
					tween.update(1000 / frameRate);
				}
				else
				{
					readCompleteHandler();
					break;
				}
			}
			while (getTimer() - t < limitTimeInFrame)
		}
		
		private function readCompleteHandler():void
		{
			this.timer.removeEventListener(TimerEvent.TIMER,timeHandler);
			this.timer.stop();
			this.timer = null;
			
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