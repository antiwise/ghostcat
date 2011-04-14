package ghostcat.game.layer.position
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Point;

	/**
	 * 网格坐标转换器 
	 * @author flashyiyi
	 * 
	 */
	public class TilePositionManager extends SimplePositionManager
	{
		/**
		 * 网格宽度
		 */
		public var tileWidth:Number;
		/**
		 * 网格高度
		 */
		public var tileHeight:Number;
		public function TilePositionManager(tileWidth:Number,tileHeight:Number,offestX:Number = 0.0,offestY:Number = 0.0):void
		{
			super(offestX,offestY);
			
			this.tileWidth = tileWidth;
			this.tileHeight = tileHeight;
			
		}
		public override function untransform(p:Point):Point
		{
			return new Point(p.x / tileWidth - offestX, p.y / tileHeight - offestY);
		}
		
		public override function transform(p:Point):Point
		{
			return new Point(p.x * tileWidth + offestX, p.y * tileHeight + offestY);
		}
		
		public function createGridLines(width:int,height:int,color:uint = 0xFF0000):Shape
		{
			var s:Shape = new Shape();
			s.graphics.lineStyle(0,color);
			for (var i:int = 0;i <= width;i++)
				drawLine(s.graphics,i,0,i,height);
		
			for (var j:int = 0;j <= height;j++)
				drawLine(s.graphics,0,j,width,j);
			
			s.cacheAsBitmap = true;
			return s;
		}
		
		protected function drawLine(g:Graphics,x1:int,y1:int,x2:int,y2:int):void
		{
			var p:Point;
			p = transform(new Point(x1,y1));
			g.moveTo(p.x,p.y);
			p = transform(new Point(x2,y2));
			g.lineTo(p.x,p.y);
		}
		
	}
}