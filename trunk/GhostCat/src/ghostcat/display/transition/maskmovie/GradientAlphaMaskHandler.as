package ghostcat.display.transition.maskmovie
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import ghostcat.display.movieclip.GScriptMovieClip;
	import ghostcat.util.core.Handler;
	
	/**
	 * 透明渐变滑动动画
	 * @author flashyiyi
	 * 
	 */
	public class GradientAlphaMaskHandler extends Handler
	{
		public var rotation:Number;
		public function GradientAlphaMaskHandler(rotation:Number = 0)
		{
			this.rotation = rotation;
			super();
		}
		
		/** @inheritDoc*/
		public override function call(...params) : *
		{
			var mc:GScriptMovieClip = params[0];
			var graphics:Graphics = (mc.content as Sprite).graphics;
			var bounds:Rectangle = mc.bounds;
			
			var p:Number = 1 - mc.currentFrame / mc.totalFrames;
			var m:Matrix = new Matrix();
			m.createGradientBox(bounds.width * 3,bounds.height * 3,rotation / 180 * Math.PI,bounds.x - bounds.width,bounds.y - bounds.height);
			
			graphics.clear();
			graphics.beginGradientFill(GradientType.LINEAR,[0,0],[1,0],[0,255 * p],m);
			graphics.drawRect(bounds.x,bounds.y,bounds.width,bounds.height);
			graphics.endFill();
		}
	}
}