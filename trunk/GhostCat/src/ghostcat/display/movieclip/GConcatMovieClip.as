package ghostcat.display.movieclip
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	
	/**
	 * 动画首尾拼接类 
	 * @author flashyiyi
	 * 
	 */
	public class GConcatMovieClip extends GMovieClipBase
	{
		protected var mcs:Array;
		
		private var mcStartFrame:Array;
		
		
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
			
			var mcFrame:int = frame - curStartFrame;
			
			if (mc)
			{
				if (mcFrame == currentFrame + 1) 
					mc.nextFrame();
				else if (mcFrame == currentFrame - 1)
					mc.prevFrame();
				else
					mc.gotoAndStop(mcFrame);
			}
			
			super.currentFrame = frame;
		}
	}
}