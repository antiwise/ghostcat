package ghostcat.display.transition.maskmovie
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import ghostcat.display.movieclip.GScriptMovieClip;
	import ghostcat.util.core.Handler;
	
	/**
	 * 透明渐变动画
	 * @author flashyiyi
	 * 
	 */
	public class AlphaMaskHandler extends Handler
	{
		public var startAlpha:Number;
		public var endAlpha:Number;
		public function AlphaMaskHandler(startAlpha:Number = 1.0,endAlpha:Number = 0.0)
		{
			this.startAlpha = startAlpha;
			this.endAlpha = endAlpha;
			
			super();
		}
		
		/** @inheritDoc*/
		public override function call(...params) : *
		{
			var mc:GScriptMovieClip = params[0];
			var graphics:Graphics = (mc.content as Sprite).graphics;
			var bounds:Rectangle = mc.bounds;
			
			graphics.clear();
			var alpha:Number = startAlpha + (endAlpha - startAlpha) / mc.totalFrames * mc.currentFrame;
			if (alpha == 0.0)
				alpha = 0.01;//完全透明时Mask会失效
			graphics.beginFill(0,alpha);
			graphics.drawRect(bounds.x,bounds.y,bounds.width,bounds.height);
			graphics.endFill();
		}
	}
}