package ghostcat.display.viewport
{
	import flash.geom.Point;

	public class Tile45TopLeft extends Tile45
	{
		public function Tile45TopLeft(itemClass:*=null)
		{
			super(itemClass);
		}
		
		/** @inheritDoc*/
		override public function displayToItem(p:Point):Point
		{
			return super.displayToItem(new Point(p.x + contentRect.width / 2,p.y));
		}
		
		/** @inheritDoc*/
		override public function itemToDisplay(p:Point):Point
		{
			var p:Point = super.itemToDisplay(p);
			return new Point(p.x - contentRect.width / 2,p.y);
		}
	}
}