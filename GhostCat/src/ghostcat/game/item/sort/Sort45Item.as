package ghostcat.game.item.sort
{
	import flash.display.DisplayObject;
	
	import ghostcat.display.game.Display45Util;

	public class Sort45Item implements ISortItem
	{
		/**
		 * 网格宽高比
		 */
		static public var wh:Number = 2.0;
		/**
		 * 最大场景宽度
		 */
		static public var maxViewportWidth:Number = 50000;
		
		public var target:DisplayObject;
		public var offestY:Number = 0.0;
		
		private var _priority:Number;
		
		public function Sort45Item(target:DisplayObject)
		{
			this.target = target;
		}
		
		public function calculate():void
		{
			var targetX:Number = target.x;
			var targetY:Number = target.y + offestY;
			var x:Number = targetX + targetY * wh
			var y:Number = targetY - targetX / wh;
			_priority = x + y * maxViewportWidth; 
		}
		
		public function get priority():Number
		{
			return _priority;
		}
	}
}