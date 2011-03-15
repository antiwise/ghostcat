package ghostcat.game.layer.position
{
	import flash.geom.Point;

	public class SimplePositionManager implements IPositionManager
	{
		public var offestX:Number;
		public var offestY:Number;
		
		public function SimplePositionManager(offestX:Number = 0.0,offestY:Number = 0.0):void
		{
			this.offestX = offestX;
			this.offestY = offestY;
		}
		
		public function getObjectPosition(obj:*):Point
		{
			return new Point(obj.x - offestX,obj.y - offestY);
		}
		
		public function setObjectPosition(obj:*, p:Point):void
		{
			obj.x = p.x + offestX;
			obj.y = p.y + offestY;
		}
		
	}
}