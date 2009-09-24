package ghostcat.display.movieclip
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	
	import ghostcat.events.MoveEvent;
	import ghostcat.events.MovieEvent;
	import ghostcat.debug.Debug;
	import ghostcat.util.Handler;
	import ghostcat.util.Util;
	
	/**
	 * 使用位图数组的动画剪辑，用法和GMovieClip基本相同
	 * 
	 * @author flashyiyi
	 * 
	 */	
	
	public class GBitmapMovieClip extends GMovieClipBase
	{
		
		private var _bitmaps:Array;
		
		private var _labels:Array;
		
		private var _currentFrame:int = 1;
		
		/**
		 * 
		 * @param bitmaps	源位图数组
		 * @param labels	标签数组，内容为FrameLabel类型
		 * @param paused	是否暂停
		 * 
		 */
		 		
		public function GBitmapMovieClip(bitmaps:Array,labels:Array=null,paused:Boolean=false)
		{
			this._bitmaps = bitmaps;
			this._labels = labels ? labels : [];
			
			super(new Bitmap(bitmaps[0]),true,paused);
			
			clearQueue();
			if (labels)
				setLabel(labels[0],-1);
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
		public override function destory():void
		{
			super.destory();
			
			for (var i:int = 0;i < _bitmaps.length;i++)
				(_bitmaps[i] as BitmapData).dispose();
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
        		
        	(content as Bitmap).bitmapData = _bitmaps[frame - 1];
        	
        	_currentFrame = frame;
        }
        /** @inheritDoc*/
        public override function get totalFrames():int
        {
        	return _bitmaps.length;
        }
        /** @inheritDoc*/
        public override function get labels():Array
		{
			return _labels;
		}
		
        /** @inheritDoc*/
        public override function nextFrame():void
        {
        	currentFrame ++;
        }
        
        
	}
}