package ghostcat.game.layer.position
{
	import flash.geom.Point;

	public class TilePositionManager implements IPositionManager
	{
		public var tileWidth:Number;
		public var tileHeight:Number;
		public function TilePositionManager(tileWidth:Number,tileHeight:Number):void
		{
			this.tileWidth = tileWidth;
			this.tileHeight = tileHeight;
			
		}
		public function getObjectPosition(obj:*):Point
		{
			return new Point(obj.x / tileWidth,obj.y / tileHeight);
		}
		
		public function setObjectPosition(obj:*, p:Point):void
		{
			obj.x = p.x * tileWidth;
			obj.y = p.y * tileHeight;
		}
		
	}
}