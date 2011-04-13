package ghostcat.operation
{
	import flash.display.MovieClip;
	
	import ghostcat.display.movieclip.GMovieClip;
	import ghostcat.display.movieclip.GMovieClipBase;
	import ghostcat.events.MovieEvent;

	/**
	 * 动画播放
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class MovieOper extends Oper
	{
		/**
		 * 动画实例
		 */
		public var mc:GMovieClipBase;
		/**
		 * 标签名
		 */
		public var labelName:String;
		/**
		 * 循环次数 
		 */
		public var loop:int;
		
		public function MovieOper(mc:*=null,labelName:String=null,loop:int = 1)
		{
			if (mc is MovieClip)
				this.mc = new GMovieClip(mc);
			else if (mc is GMovieClipBase)
				this.mc = mc;
			
			this.labelName = labelName;
			this.loop = loop;
		}
		/** @inheritDoc*/
		public override function execute():void
		{
			super.execute();
			
			mc.addEventListener(MovieEvent.MOVIE_END,result);
			
			if (mc.hasLabels())
				mc.setLabel(labelName,loop);
			else
				mc.currentFrame = 1;
		}
		/** @inheritDoc*/
		protected override function end(event:* = null) : void
		{
			super.end(event);
			mc.removeEventListener(MovieEvent.MOVIE_END,result);
		}
	}
}