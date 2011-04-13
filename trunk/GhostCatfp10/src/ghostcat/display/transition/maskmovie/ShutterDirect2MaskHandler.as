package ghostcat.display.transition.maskmovie
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import ghostcat.display.movieclip.GScriptMovieClip;
	import ghostcat.util.core.Handler;
	
	/**
	 * 百叶窗定向展开（2）
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ShutterDirect2MaskHandler extends Handler
	{
		public var width:Number;
		public var type:int;
		
		public function ShutterDirect2MaskHandler(width:Number = 50,type:int = 0)
		{
			this.width = width;
			this.type = type;
			
			super();
		}
		
		/** @inheritDoc*/
		public override function call(...params) : *
		{
			var mc:GScriptMovieClip = params[0];
			var graphics:Graphics = (mc.content as Sprite).graphics;
			var bounds:Rectangle = mc.bounds;
			
			var p:Number = 1 - mc.currentFrame / mc.totalFrames;
			
			graphics.clear();
			graphics.beginFill(0,0);
			graphics.drawRect(bounds.x,bounds.y,bounds.width,bounds.height);
			graphics.endFill();
			graphics.beginFill(0);
			var w:int;
			var m:int;
			switch (type)
			{
				case 0:
					w = int(bounds.width * p / width) * width;
					m = (bounds.width * p) % width;
					graphics.drawRect(bounds.x,bounds.y,w,bounds.height);
					graphics.drawRect(bounds.x + w,bounds.y, width ,bounds.height * m / width);
					break;
				case 1:
					w = int(bounds.width * p / width) * width;
					m = (bounds.width * p) % width;
					graphics.drawRect(bounds.x + bounds.width,bounds.y,-w,bounds.height);
					graphics.drawRect(bounds.x + bounds.width - w,bounds.y, -width ,bounds.height *  m / width);
					break;
				case 2:
					w = int(bounds.height * p / width) * width;
					m = (bounds.height * p) % width;
					graphics.drawRect(bounds.x,bounds.y,bounds.width,w);
					graphics.drawRect(bounds.x,bounds.y + w, bounds.width *  m / width, width);
					break;
				case 3:
					w = int(bounds.height * p / width) * width;
					m = (bounds.height * p) % width;
					graphics.drawRect(bounds.x,bounds.y + bounds.height,bounds.width,-w);
					graphics.drawRect(bounds.x,bounds.y + bounds.height - w, bounds.width *  m / width, -width);
					break;
			}
			graphics.endFill();
		}
	}
}