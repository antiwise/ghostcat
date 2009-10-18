package ghostcat.display.movieclip
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.FrameLabel;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.debug.Debug;
	import ghostcat.display.bitmap.BitmapMouseChecker;
	import ghostcat.display.bitmap.IBitmapDataDrawer;
	import ghostcat.util.display.GraphicsUtil;
	
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
		
		private var _labels:Array;
		private var _currentFrame:int = 1;
		
		/**
		 * 鼠标事件对象
		 */
		public var bitmapMouseChecker:BitmapMouseChecker;
		
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
			
			this.bitmaps = bitmaps;
			this._labels = labels ? labels : [];
			
			super(new Bitmap(bitmaps[0]),true,paused);
			
			reset();
			
			this.mouseEnabled = this.mouseChildren = false;
		}
		
		/** @inheritDoc*/
		protected override function init() : void
		{
			bitmapMouseChecker = new BitmapMouseChecker(content as Bitmap);
			super.init();
		}
		
		/** @inheritDoc*/
		public override function setContent(skin:*, replace:Boolean=true):void
		{
			if (content)
				Debug.error("不允许执行setContent方法")
			else
				super.setContent(skin,replace);
		}
		
		/** @inheritDoc*/
		public override function get curLabelName():String
		{
			for (var i:int = labels.length - 1;i>=0;i--)
        	{
        		if ((labels[i] as FrameLabel).frame <= currentFrame)
        			return (labels[i] as FrameLabel).name;
        	}
        	return null;
		}
		/** @inheritDoc*/
		public override function get currentFrame():int
        {
        	return _currentFrame;
        }
        /** @inheritDoc*/
        public override function set currentFrame(frame:int):void
        {
        	if (frame < 1)
        		frame = 1;
        	if (frame > totalFrames)
        		frame = totalFrames;
        		
        	(content as Bitmap).bitmapData = bitmaps[frame - 1];
        	
        	_currentFrame = frame;
        }
        /** @inheritDoc*/
        public override function get totalFrames():int
        {
        	return bitmaps.length;
        }
        
        /** @inheritDoc*/
        public override function get labels():Array
		{
			return _labels;
		}
		
		public function set labels(v:Array):void
        {
        	_labels = v;
        }
        
        /** @inheritDoc*/
        public override function nextFrame():void
        {
        	(frameRate >= 0) ? currentFrame ++ : currentFrame --;
        }

        /**
         * 回收位图资源 
         * 
         */
        public function dispose():void
        {
        	for each (var bitmapData:BitmapData in bitmaps.length)
        		bitmapData.dispose();
        } 
		
		/** @inheritDoc*/
		public override function destory():void
		{
			if (destoryed)
				return;
			
			dispose();
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
		 * @return 
		 * 
		 */
		public function createFromMovieClip(mc:MovieClip,rect:Rectangle=null,start:int = 1,len:int = -1):void
		{
			var cacher:MovieClipCacher = new MovieClipCacher(mc,rect,start,len);
			cacher.addEventListener(Event.COMPLETE,cacherCompleteHandler);
		}
		
		private function cacherCompleteHandler(event:Event):void
		{
			var cacher:MovieClipCacher = event.currentTarget as MovieClipCacher;
			cacher.removeEventListener(Event.COMPLETE,cacherCompleteHandler);
			
			this.bitmaps = cacher.result;
			this.labels = cacher.mc.currentLabels;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/** @inheritDoc*/
		public function drawToBitmapData(target:BitmapData,offest:Point):void
		{
			var bitmapData:BitmapData = (content as Bitmap).bitmapData;
			if (bitmapData)
				target.copyPixels(bitmapData,bitmapData.rect,position.add(offest));
		}
		
		/** @inheritDoc*/
		public function drawToShape(target:Graphics,offest:Point):void
		{
			GraphicsUtil.drawBitmpData(target,(content as Bitmap).bitmapData,new Point(x,y).add(offest));
		}
		
		/** @inheritDoc*/
		public function getBitmapUnderMouse(mouseX:Number,mouseY:Number):Array
		{
			var bitmapData:BitmapData = (content as Bitmap).bitmapData;
			return (uint(bitmapData.getPixel32(mouseX - x,mouseY - y) >> 24) > 0) ? [this] : null;
		}
	}
}