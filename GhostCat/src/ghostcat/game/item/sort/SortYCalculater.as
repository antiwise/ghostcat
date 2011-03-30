package ghostcat.game.item.sort
{
	import flash.display.DisplayObject;
	

	/**
	 * 深度计算模块 
	 * @author tangwei
	 * 
	 */
	public class SortYCalculater implements ISortCalculater
	{
		private var _target:DisplayObject;

		public function get target():DisplayObject
		{
			return _target;
		}

		public function set target(value:DisplayObject):void
		{
			_target = value;
		}

		public var offestY:Number = 0.0;
		
		public function SortYCalculater(target:DisplayObject)
		{
			this.target = target;
		}
		
		public function calculate():Number
		{
			return _target.y + offestY;
		}
	}
}