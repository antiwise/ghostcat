package ghostcat.display.transfer.effect
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.util.core.Handler;
	
	public class PaperDropHandler extends Handler
	{
		public var rowHeight:int;
		public function PaperDropHandler(rowHeight:int = 30)
		{
			super();
			this.rowHeight = rowHeight;
		}
		
		/** @inheritDoc*/
		public override function call(...params) : *
		{
			var normalBitmapData:BitmapData = params[0];
			var bitmapData:BitmapData = params[1];
			var deep:Number = params[2];
			
			var h:int = normalBitmapData.height * deep;
			var i:int = int(h / rowHeight);
			var r:Number = h % rowHeight;
			var dy:Number = Math.min(r * 1.75,rowHeight) / rowHeight;
			
			bitmapData.fillRect(bitmapData.rect,0);
			bitmapData.copyPixels(normalBitmapData,new Rectangle(0,0,normalBitmapData.width,i * rowHeight),new Point());
			
			var m:Matrix = new Matrix();
			m.translate(0,-i * rowHeight);
			m.scale(1,dy);
			m.translate(0,i * rowHeight);
			var c:ColorTransform = new ColorTransform(1,1,1,1,-(1 - dy) * 100,-(1 - dy) * 100,-(1 - dy) * 100);
			
			bitmapData.draw(normalBitmapData,m,c,null,new Rectangle(0,i * rowHeight,normalBitmapData.width,dy * rowHeight));
		}
	}
}