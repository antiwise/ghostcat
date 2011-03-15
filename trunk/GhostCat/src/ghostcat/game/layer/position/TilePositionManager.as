package ghostcat.game.layer.position
{
	import flash.geom.Point;

	public class TilePositionManager extends SimplePositionManager
	{
		public var tileWidth:Number;
		public var tileHeight:Number;
		public function TilePositionManager(tileWidth:Number,tileHeight:Number,offestX:Number = 0.0,offestY:Number = 0.0):void
		{
			super(offestX,offestY);
			
			this.tileWidth = tileWidth;
			this.tileHeight = tileHeight;
			
		}
		public override function getObjectPosition(obj:*):Point
		{
			return new Point(obj.x / tileWidth - offestX,obj.y / tileHeight - offestY);
		}
		
		public override function setObjectPosition(obj:*, p:Point):void
		{
			obj.x = p.x * tileWidth + offestX;
			obj.y = p.y * tileHeight + offestY;
		}
		
	}
}