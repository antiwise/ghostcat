package ghostcat.display.movieclip
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.display.bitmap.BitmapMouseChecker;
	import ghostcat.display.bitmap.IBitmapDataDrawer;
	import ghostcat.parse.graphics.GraphicsBitmapFill;
	
	[Event(name="complete",type="flash.events.Event")]
	
	/**
	 * 使用位图数组的动画剪辑，用法和GMovieClip基本相同
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class GBitmapMovieClip extends GMovieClipBase implements IBitmapDataDrawer
	{
		/**
		 * 位图数组
		 */
		public var bitmaps:Array;
		
		/**
		 * 是否在销毁的时候自动回收位图
		 */
		public var disposeWhenDestory:Boolean = true;
		
		/**
		 * 鼠标事件对象
		 */
		public var bitmapMouseChecker:BitmapMouseChecker;
		
		/**
		 * 进行位图缓存时，可以用它来控制缓存过程
		 */
		public var movieClipCacher:MovieClipCacher
		
		private var _enableMouseEvent:Boolean;
		
		/**
		 * 
		 * @param bitmaps	源位图数组
		 * @param labels	标签数组，内容为FrameLabel类型
		 * @param paused	是否暂停
		 * 
		 */
		 		
		public function GBitmapMovieClip(bitmaps:Array=null,labels:Array=null,paused:Boolean=false)
		{
			if (!bitmaps)
				bitmaps = [];
			
			super(new Bitmap(),true,paused);
			
			this.bitmaps = bitmaps;
			this.labels = labels;
			
			if (bitmaps && bitmaps.length > 0)
				(content as Bitmap).bitmapData = bitmaps[0];
			
			this.mouseEnabled = this.mouseChildren = false;
		}
		
		/** @inheritDoc*/
		protected override function init() : void
		{
			bitmapMouseChecker = new BitmapMouseChecker(content as Bitmap);
			bitmapMouseChecker.enabled = _enableMouseEvent;
			super.init();
		}
		
		/**
		 * 是否激活模拟鼠标事件
		 * @return 
		 * 
		 */
		public function get enableMouseEvent():Boolean
		{
			return _enableMouseEvent;
		}
		
		public function set enableMouseEvent(value:Boolean):void
		{
			_enableMouseEvent = value;
			if (bitmapMouseChecker)
				bitmapMouseChecker.enabled = value;
		}
		
		/**
		 * 将显示内容放在另一个Bitmap对象上
		 */
		public function linkBitmap(v:Bitmap):void
		{
			setContent(v,false);
		}
		
		/** @inheritDoc*/
		public override function set currentFrame(frame:int):void
		{
			if (frame < 1)
				frame = 1;
			if (frame > totalFrames)
				frame = totalFrames;
			
			if (super.currentFrame == frame)
				return;
			
			super.currentFrame = frame;
				
			(content as Bitmap).bitmapData = bitmaps[frame - 1];
				
		}
		
		/** @inheritDoc*/
        public override function get totalFrames():int
        {
        	return bitmaps.length;
        }
        
        /**
         * 回收位图资源 
         * 
         */
        public function dispose():void
        {
        	for each (var bitmapData:BitmapData in bitmaps)
        		bitmapData.dispose();
        } 
		
		/** @inheritDoc*/
		public override function destory():void
		{
			if (destoryed)
				return;
			
			if (disposeWhenDestory)
				dispose();
			
			if (bitmapMouseChecker)
				bitmapMouseChecker.destory();
			
			super.destory();
		}
		
		/**
		 * 从一个MovieClip生成
		 * 注意这个缓存是需要时间的，如果要在完全生成GBitmapMovieClip对象后进行一些操作，可监听GBitmapMovieClip的complete事件
         * 
		 * @param mc	要转换的电影剪辑
		 * @param rect	绘制范围
		 * @param start	起始帧
		 * @param len	长度
		 * @param readWhenPlaying 是否在播放时顺便缓存
		 * @param limitTimeInFrame	每次缓存允许的最高时间
		 * @return 
		 * 
		 */
		public function createFromMovieClip(mc:MovieClip,rect:Rectangle=null,start:int = 1,len:int = -1,readWhenPlaying:Boolean = false,limitTimeInFrame:int = 0):void
		{
			movieClipCacher = new MovieClipCacher(mc,rect,start,len,readWhenPlaying,limitTimeInFrame);
			
			if (readWhenPlaying)
				movieClipCacher.result = bitmaps;
			
			movieClipCacher.addEventListener(Event.COMPLETE,cacherCompleteHandler);
		}
		
		/**
		 * 当createFromMovieClip执行后，立即缓存完所有的帧 
		 * 
		 */
		public function renderAllFrames():void
		{
			if (movieClipCacher)
				movieClipCacher.renderAllFrames();
		}
		
		private function cacherCompleteHandler(event:Event):void
		{
			movieClipCacher.removeEventListener(Event.COMPLETE,cacherCompleteHandler);
			
			this.bitmaps = movieClipCacher.result;
			this.labels = movieClipCacher.mc.currentLabels;
			this.dispatchEvent(new Event(Event.COMPLETE));
			
			movieClipCacher = null;
		}
		
		/** @inheritDoc*/
		public function drawToBitmapData(target:BitmapData,offest:Point):void
		{
			var bitmapData:BitmapData = (content as Bitmap).bitmapData;
			if (bitmapData)
				target.copyPixels(bitmapData,bitmapData.rect,position.add(offest),null,null,target.transparent);
		}
		
		/** @inheritDoc*/
		public function getBitmapUnderMouse(mouseX:Number,mouseY:Number):Array
		{
			var bitmapData:BitmapData = (content as Bitmap).bitmapData;
			return (uint(bitmapData.getPixel32(mouseX - x,mouseY - y) >> 24) > 0) ? [this] : null;
		}
	}
}