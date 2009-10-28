package ghostcat.display.transition.maskmovie
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.display.movieclip.GScriptMovieClip;
	import ghostcat.util.core.Handler;
	
	/**
	 * 溶解
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class DissolveMaskHandler extends Handler
	{
		public var size:int;
		public var randSeed:Number;
		public var bitmapData:BitmapData;
		public function DissolveMaskHandler(size:Number = 10,randSeed:Number = NaN)
		{
			if (!isNaN(randSeed))
				randSeed = new Date().getTime();
			
			this.size = size;
			this.randSeed = randSeed;
			
			super();
		}
		
		/** @inheritDoc*/
		public override function call(...params) : *
		{
			var mc:GScriptMovieClip = params[0];
			var graphics:Graphics = (mc.content as Sprite).graphics;
			var bounds:Rectangle = mc.bounds;
			
			if (!bitmapData)
				bitmapData = new BitmapData(bounds.width / size,bounds.height / size,true,0);
			
			bitmapData.fillRect(bitmapData.rect,0xFF000000);
			bitmapData.pixelDissolve(bitmapData,bitmapData.rect,new Point(),randSeed,bitmapData.width * bitmapData.height * mc.currentFrame / mc.totalFrames);
			var m:Matrix = new Matrix();
			m.scale(size,size);
			m.translate(bounds.x,bounds.y);
			
			graphics.clear();
			graphics.beginBitmapFill(bitmapData,m,false);
			graphics.drawRect(bounds.x,bounds.y,bounds.width,bounds.height);
			graphics.endFill();
		}
		
		public override function destory() : void
		{
			if (bitmapData)
				bitmapData.dispose();
			
			super.destory();
		}
	}
}