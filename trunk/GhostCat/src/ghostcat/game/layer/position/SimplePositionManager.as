package ghostcat.game.layer.position
{
	import flash.geom.Point;

	public class SimplePositionManager implements IPositionManager
	{
		public function getObjectPosition(obj:*):Point
		{
			return new Point(obj.x,obj.y);
		}
		
		public function setObjectPosition(obj:*, p:Point):void
		{
			obj.x = p.x;
			obj.y = p.y;
		}
		
	}
}