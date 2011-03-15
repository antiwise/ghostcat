package ghostcat.game.layer.position
{
	import flash.geom.Point;
	
	import ghostcat.display.game.Display45Util;

	public class Tile45PositionManager implements IPositionManager
	{
		public var tileWidth:Number;
		public var tileHeight:Number;
		public function Tile45PositionManager(tileWidth:Number,tileHeight:Number):void
		{
			this.tileWidth = tileWidth;
			this.tileHeight = tileHeight;
			
		}
		public function getObjectPosition(obj:*):Point
		{
			var x:Number = obj.x;
			var y:Number = obj.y;
			var wh:Number = tileWidth / tileHeight;
			return new Point((x + y * wh) / tileWidth,(y - x / wh) / tileHeight);
		}
		
		public function setObjectPosition(obj:*, p:Point):void
		{
			var x:Number = p.x;
			var y:Number = p.y;
			var wh:Number = tileWidth / tileHeight;
			obj.x = (x - y * wh) / 2 * tileWidth;
			obj.y = (x / wh + y) / 2 * tileHeight;
		}
	}
}