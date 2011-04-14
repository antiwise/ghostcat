package ghostcat.display.transition.maskmovie
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import ghostcat.display.movieclip.GScriptMovieClip;
	import ghostcat.util.core.Handler;
	import ghostcat.util.easing.Linear;
	
	/**
	 * 填充方块移动
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class RectMaskHandler extends Handler
	{
		public var targetX:Number;
		public var targetY:Number;
		public var ease:Function;
		
		public function RectMaskHandler(targetX:Number,targetY:Number,ease:Function = null)
		{
			this.targetX = targetX;
			this.targetY = targetY;
			this.ease = ease;
			
			super();
		}
		
		/** @inheritDoc*/
		public override function call(...params) : *
		{
			var mc:GScriptMovieClip = params[0];
			var graphics:Graphics = (mc.content as Sprite).graphics;
			var bounds:Rectangle = mc.bounds;
			
			if (ease == null)
				ease = Linear.easeOut;
			
			var x:Number = ease(mc.currentFrame, 0, targetX, mc.totalFrames);
			var y:Number = ease(mc.currentFrame, 0, targetY, mc.totalFrames);
			
			graphics.clear();
			graphics.beginFill(0);
			graphics.drawRect(bounds.x + x,bounds.y + y,bounds.width,bounds.height);
			graphics.endFill();
		}
	}
}