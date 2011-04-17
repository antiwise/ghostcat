package ghostcat.display.transition.maskmovie
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import ghostcat.display.movieclip.GScriptMovieClip;
	import ghostcat.util.core.Handler;
	
	/**
	 * 方格百叶窗
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ShutterMaskHandler extends Handler
	{
		public var width:Number;
		public var height:Number;
		
		public function ShutterMaskHandler(width:Number = 50,height:Number = 50)
		{
			this.width = width;
			this.height = height;
			
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
			var il:int = Math.ceil(bounds.width / width);
			var jl:int = Math.ceil(bounds.height / height);
			for (var j:int = 0;j < jl;j++)
			{
				for (var i:int = 0;i < il;i++)
				{
					if ((i + j) % 2)
						graphics.drawRect(bounds.x + i * width,bounds.y + j * height,width,height * p);
					else
						graphics.drawRect(bounds.x + i * width,bounds.y + j * height + height * (1 - p),width,height * p);
					
				}
			}
			graphics.endFill();
		}
	}
}