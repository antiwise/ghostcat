package ghostcat.parse.graphics
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	
	import ghostcat.parse.DisplayParse;

	public class GraphicsBitmapFill extends DisplayParse implements IGraphicsFill
	{
		public var bitmap:BitmapData;
		public var matrix:Matrix;
		public var repeat:Boolean;
		public var smooth:Boolean;
		public function GraphicsBitmapFill(bitmap:BitmapData,matrix:Matrix=null,repeat:Boolean=true,smooth:Boolean=false)
		{
			this.bitmap = bitmap;
			this.matrix = matrix;
			this.repeat = repeat;
			this.smooth = smooth;
		}
		
		/** @inheritDoc*/
		public override function parseGraphics(target:Graphics):void
		{
			super.parseGraphics(target);
			target.beginBitmapFill(bitmap,matrix,repeat,smooth);
		}
		
		/**
		 * 绘制一个位图到画布上 
		 * @param target
		 * @param bitmapData
		 * @param pos
		 * 
		 */
		public static function drawBitmpData(target:Graphics,bitmapData:BitmapData,x:Number,y:Number,width:Number = NaN,height:Number = NaN):void
		{
			if (bitmapData)
			{
				var m:Matrix = new Matrix();
				m.translate(x,y);
				if (isNaN(width))
					width = bitmapData.width;
				if (isNaN(height))
					height = bitmapData.height;
				
				var sx:Number = width / bitmapData.width;
				var sy:Number = height / bitmapData.height;
				m.scale(sx,sy);
				
				target.beginBitmapFill(bitmapData,m,false,false);
				target.drawRect(x,y,width,height);
				target.endFill();
			}
		}
	}
}