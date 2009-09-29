package ghostcat.community.command
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;

	/**
	 * 45度角景深排序
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class DrawPriority45Command
	{
		private static var wh:Number = 1;
		
		/**
		 * 设置单个格子的大小
		 * @param w
		 * @param h
		 * 
		 */
		public static function setContentSize(w:Number,h:Number):void
		{
			wh = w / h;
		}
		
		/**
		 * 45度角排序
		 *  
		 * @param d1
		 * @param d2
		 * 
		 */
		public static function SORT45(d1:DisplayObject,d2:DisplayObject):void
		{
			if (d1.parent != d2.parent)
				return;
			
			var parent:DisplayObjectContainer = d1.parent;
			
			var i1:int = parent.getChildIndex(d1);
			var i2:int = parent.getChildIndex(d2);
			var isHighIndex:Boolean = i1 > i2; 
			var p1:Point = new Point(d1.x + d1.y * wh,d1.y - d1.x/wh)
			var p2:Point = new Point(d2.x + d2.y * wh,d2.y - d2.x/wh)
			var isHighValue:Boolean = p1.x > p2.x || p1.y > p2.y;
			
			if (isHighIndex != isHighValue)
				parent.swapChildren(d1,d2);
		}

	}
}