package ghostcat.display.movieclip
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import ghostcat.skin.ButtonSkin;
	
	/**
	 * 动画首尾拼接 
	 * @author flashyiyi
	 * 
	 */
	public class GConcatMovieClip extends GMovieClipBase
	{
		protected var mcs:Array;
		
		private var mcStartFrame:Array;
		
		private var _labels:Array;
		private var _currentFrame:int = 1;
		private var _totalFrames:int = 1;
		
		/**
		 * 
		 * @param mc	目标动画
		 * @param replace	是否替换
		 * @param paused	是否暂停
		 * 
		 */
		public function GConcatMovieClip(mcs:Array=null, replace:Boolean=true, paused:Boolean=false)
		{
			this.mcs = mcs;
			
			var mc:MovieClip;
			if (mcs && mcs.length > 0)
				mc = mcs[0] as MovieClip;
			
			super(mc, replace, paused);
			
			if (mcs)
			{
				_totalFrames = 0;
				_labels = [];
				mcStartFrame = [];
				for (var index:int = 0;index < mcs.length;index++)
				{
					mc = mcs[index] as MovieClip;
					mcStartFrame.push(_totalFrames);
					
					var mcLabels:Array = mc.currentLabels;
					for (var i:int = 0;i < mcLabels.length;i++)
					{
						var fl:FrameLabel = mcLabels[i] as FrameLabel;
						_labels.push(new FrameLabel(fl.name,_totalFrames + fl.frame));
					}
					_totalFrames += mc.totalFrames;
				}
			}
			
			reset();
		}
		
		/**
		 * 动画对象 
		 * @return 
		 * 
		 */
		protected function get mc():MovieClip
		{
			return content as MovieClip;
		}
		
		/** @inheritDoc*/
		public override function setContent(skin:*, replace:Boolean=true):void
		{
			super.setContent(skin,replace);
			
			if (mc)
				mc.stop();
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
			
			var curMc:MovieClip;
			var curStartFrame:int;
			for (var i:int = 0;i < mcStartFrame.length;i++)
			{
				if (_currentFrame >= mcStartFrame[i])
				{
					curMc = mcs[i] as MovieClip;
					curStartFrame = mcStartFrame[i];
					break;
				}
			}
			if (curMc != content)
				setContent(curMc);
			
			mc.gotoAndStop(frame - curStartFrame);
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
			(frameRate >= 0) ? currentFrame ++ : currentFrame --;
		}
	}
}