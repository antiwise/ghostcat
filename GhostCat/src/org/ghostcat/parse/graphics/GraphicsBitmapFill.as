package org.ghostcat.parse.graphics
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	
	import org.ghostcat.parse.DisplayParse;

	public class GraphicsBitmapFill extends DisplayParse
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
		
		protected override function parseGraphics(target:Graphics) : void
		{
			super.parseGraphics(target);
			target.beginBitmapFill(bitmap,matrix,repeat,smooth);
		}
	}
}