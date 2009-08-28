package org.ghostcat.bitmap
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	[Event(name="complete",type="flash.events.Event")]
	
	/**
	 * 将电影剪辑缓存为位图数组的类，可以将其转移到GBitmapMovieClip进行播放
	 * 
	 * @see org.ghostcat.display.movieclip.GBitmapMovieClip
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
		 * 绘制偏移量
		 */
		public var offest:Point;
		
		/**
		 * 绘制大小 
		 */		
		public var size:Point;
		
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
		
		public function MovieClipCacher(mc:MovieClip,size:Point=null,offest:Point=null,start:int = 1,len:int = -1)
		{
			if (mc)
				read(mc,size,offest,start,len);
		}
		
		/**
		 * 缓存动画
		 *  
		 * @param mc		要缓存的动画
		 * @param size		动画大小
		 * @param offest	绘制偏移量
		 * @param start		起始帧
		 * @param len		长度
		 * 
		 */
		public function read(mc:MovieClip,size:Point=null,offest:Point=null,start:int = 1,len:int = -1):void
		{
			this.mc = mc;
			
			this.offest = offest ? offest : mc.getBounds(mc).topLeft;
			
			this.size = size ? size : new Point(mc.width,mc.height);
			
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
			
			this.timer = new Timer(5,int.MAX_VALUE);
			this.timer.addEventListener(TimerEvent.TIMER,timeHandler);
			this.timer.start();
		}
		
		private function timeHandler(event:Event):void
		{
			if (mc.currentFrame >= readFrame)
			{
				var bitmapData:BitmapData = new BitmapData(size.x,size.y);
				var m:Matrix;
				if (offest)
				{
					m = new Matrix();
					m.translate(offest.x,offest.y);
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
		
	}
}