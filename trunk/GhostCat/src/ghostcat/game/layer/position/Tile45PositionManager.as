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
		
		public override function getObjectPosition(obj:*):Point
		{
			var x:Number = obj.x;
			var y:Number = obj.y;
			var wh:Number = tileWidth / tileHeight;
			return new Point((x + y * wh) / tileWidth - offestX,(y - x / wh) / tileHeight - offestY);
		}
		
		public override function setObjectPosition(obj:*, p:Point):void
		{
			var x:Number = p.x;
			var y:Number = p.y;
			var wh:Number = tileWidth / tileHeight;
			obj.x = (x - y * wh) / 2 * tileWidth + offestX;
			obj.y = (x / wh + y) / 2 * tileHeight + offestY;
		}
	}
}