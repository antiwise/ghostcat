package ghostcat.game.item.sort
{
	import flash.display.DisplayObject;
	
	import ghostcat.game.item.IGameItem;

	public class SortYCalculater implements ISortCalculater
	{
		public var target:DisplayObject;
		public var offestY:Number = 0.0;
		
		public function SortYCalculater(target:DisplayObject)
		{
			this.target = target;
		}
		
		public function calculate():void
		{
			IGameItem(target).priority = target.y + offestY;
		}
	}
}