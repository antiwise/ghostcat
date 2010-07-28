package ghostcat.ui.controls
{
	import flash.display.MovieClip;
	
	import ghostcat.display.GBase;
	
	/**
	 * 换帧对象
	 * @author flashyiyi
	 * 
	 */
	public class GFrameBase extends GBase
	{
		public function get movie():MovieClip
		{
			return this.content as MovieClip;
		}
		
		public function GFrameBase(skin:*=null, replace:Boolean=true)
		{
			super(skin, replace);
			this.frame = 1;
		}
		
		public function set frame(v:int):void
		{
			if (movie)
				movie.gotoAndStop(v);
		}
		
		public function get frame():int
		{
			return movie ? movie.currentFrame : 0;
		}
	}
}