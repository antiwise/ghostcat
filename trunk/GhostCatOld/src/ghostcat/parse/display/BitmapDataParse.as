package ghostcat.parse.display
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import ghostcat.parse.DisplayParse;
	
	/**
	 * 在画布上绘制一个位图
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class BitmapDataParse extends DisplayParse
	{
		public var bitmapData:BitmapData;
		public var x:Number;
		public var y:Number;
		public var matrix:Matrix;
		public function BitmapDataParse(x:Number,y:Number,bitmapData:BitmapData,matrix:Matrix = null)
		{
			this.x = x;
			this.y = y;
			this.bitmapData = bitmapData;
			this.matrix = matrix;
		}
		
		/** @inheritDoc*/
		public override function parseGraphics(target:Graphics) : void
		{
			super.parseGraphics(target);
			
			if (bitmapData)
			{
				var m:Matrix;
				if (matrix)
					m = matrix.clone();
				else
					m = new Matrix();
				
				m.translate(x,y);
				
				target.beginBitmapFill(bitmapData,m,false,false);
				target.drawRect(x,y,bitmapData.width,bitmapData.height);
				target.endFill();
			}
		}
	}
}