package ghostcat.game.item.sort
{
	import flash.display.DisplayObject;

	public class SortYItem implements ISortItem
	{
		public var target:DisplayObject;
		public var offestY:Number = 0.0;
		
		private var _priority:Number;
		
		public function SortYItem(target:DisplayObject)
		{
			this.target = target;
		}
		
		public function calculate():void
		{
			_priority = target.y + offestY;
		}
		
		public function get priority():Number
		{
			return _priority;
		}
	}
}