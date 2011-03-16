package ghostcat.game.layer.position
{
	import flash.geom.Point;
	
	import ghostcat.display.game.Display45Util;

	public class Tile45PositionManager extends TilePositionManager
	{
		public function Tile45PositionManager(tileWidth:Number,tileHeight:Number,offestX:Number = 0.0,offestY:Number = 0.0):void
		{
			super(tileWidth,tileHeight,offestX,offestY);
		}
		
		public override function untransform(p:Point):Point
		{
			var x:Number = p.x;
			var y:Number = p.y;
			var wh:Number = tileWidth / tileHeight;
			return new Point((x + y * wh) / tileWidth - offestX,(y - x / wh) / tileHeight - offestY);
		}
		
		public override function transform(p:Point):Point
		{
			var x:Number = p.x;
			var y:Number = p.y;
			var wh:Number = tileWidth / tileHeight;
			return new Point((x - y * wh) / 2 * tileWidth + offestX, (x / wh + y) / 2 * tileHeight + offestY);
		}
	}
}