package ghostcat.display.movieclip
{
	import flash.display.FrameLabel;
	
	import ghostcat.debug.Debug;
	
	/**
	 * 使用动画剪辑模拟代码动画，可以再次继承此类来来处理特殊情况
	 * 
	 * @author flashyiyi
	 * 
	 */	
	
	public class GScrpitMovieClip extends GMovieClipBase
	{
		/**
		 * 渲染方法，参数为GScrpitMovieClip本身
		 */
		public var cmd:Function;
		
		private var _labels:Array;
		private var _currentFrame:int = 1;
		
		/**
		 * 
		 * @param cmd	渲染方法
		 * @param totalFrames	动画长度
		 * @param labels	标签数组，内容为FrameLabel类型
		 * @param paused	是否暂停
		 * 
		 */	
		public function GScrpitMovieClip(cmd:Function,totalFrames:int,labels:Array=null,paused:Boolean=false)
		{
			this.cmd = cmd;
			this._totalFrames = totalFrames;
			this._labels = labels ? labels : [];
			
			super(new Sprite()),true,paused);
			
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
        	
        	if (_currentFrame == frame)
        		return;
        		
        	_currentFrame = frame;
        
        	cmd.call(null,this) 
        }
        /** @inheritDoc*/
        public override function get totalFrames():int
        {
        	return _totalFrames;
        }
        
        public function set totalFrames(v:int):void
        {
        	_totalFrames = v;
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
        	currentFrame ++;
        }
	}
}