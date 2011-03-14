package ghostcat.game.item.sort
{
	import flash.display.DisplayObject;
	

	public class SortYCalculater implements ISortCalculater
	{
		public var target:DisplayObject;
		public var offestY:Number = 0.0;
		
		public function SortYCalculater(target:DisplayObject)
		{
			this.target = target;
		}
		
		public function calculate():Number
		{
			return target.y + offestY;
		}
	}
}