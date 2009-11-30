package ghostcat.parse.graphics
{
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.Shape;
	import flash.geom.Point;
	
	import ghostcat.parse.DisplayParse;
	import ghostcat.util.Util;

	/**
	 * 以线条重复作为填充 
	 * @author flashyiyi
	 * 
	 */
	public class GraphicsLineFill extends DisplayParse implements IGraphicsFill
	{
		private static var bitmaps:Array = [];
		
		public var rotation:Number;
		public var size:Number;
		public var thickness:Number;
		public var color:uint;
		public var alpha:Number;
		public var backgroundColor:uint;
		public var backgroundAlpha:Number;
		
		private var bitmap:BitmapData;
		
		public function GraphicsLineFill(rotation:Number = 0,size:Number = 2, thickness:Number = 1, color:uint=0,alpha:Number=1.0,backgroundColor:uint = 0xFFFFFF,backgroundAlpha:Number = 1.0)
		{
			this.rotation = rotation;
			this.size = size;
			this.thickness = thickness;
			this.color = color;
			this.alpha = alpha;
			this.backgroundColor = backgroundColor;
			this.backgroundAlpha = backgroundAlpha;
		}
		
		/** @inheritDoc*/
		public override function parseGraphics(target:Graphics):void
		{
			super.parseGraphics(target);
			
			if (bitmap)
			{
				bitmap.dispose();
				Util.remove(bitmaps,bitmap);
			}
			
			bitmap = new BitmapData(size,size,true,backgroundAlpha * 0xFF000000 + backgroundColor);
			bitmaps.push(bitmap);
			var s:Shape = new Shape();
			var p:Point = Point.polar(Math.SQRT2 * size, rotation / 180 * Math.PI)
			s.graphics.lineStyle(thickness,color,alpha);
			s.graphics.lineTo(p.x,p.y);
			s.graphics.moveTo(size,0);
			s.graphics.lineTo(p.x + size,p.y);
			s.graphics.moveTo(0,size);
			s.graphics.lineTo(p.x,p.y + size);
			
			bitmap.draw(s);
			
			target.beginBitmapFill(bitmap);
		}
		
		/**
		 * 回收位图 
		 * 
		 */
		public function dispose():void
		{
			if (bitmap)
				bitmap.dispose();
		}
		
		/**
		 * 回收全部位图 
		 * 
		 */
		public static function disposeAll():void
		{
			for each (var bitmap:BitmapData in bitmaps)
				bitmap.dispose();
				
			bitmaps = [];	
		}
	}
}