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
		
		public function untransform(p:Point):Point
		{
			return new Point(p.x - offestX,p.y - offestY);
		}
		
		public function transform(p:Point):Point
		{
			return new Point(p.x + offestX,p.y + offestY);
		}
		
	}
}