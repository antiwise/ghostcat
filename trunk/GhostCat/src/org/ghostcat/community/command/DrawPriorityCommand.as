package org.ghostcat.community.command
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * 景深排序
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class DrawPriorityCommand
	{
		public static function SORTY(d1:DisplayObject,d2:DisplayObject):void
		{
			if (d1.parent != d2.parent)
				return;
			
			var parent:DisplayObjectContainer = d1.parent;
			
			var isHighIndex:Boolean = parent.getChildIndex(d1) > parent.getChildIndex(d2); 
			var isHighValue:Boolean = d1.y > d2.y;
			
			if (isHighIndex != isHighValue)
				parent.swapChildren(d1,d2);
		}
		
		public static function PRIORITY(d1:DisplayObject,d2:DisplayObject):void
		{
			if (d1.parent != d2.parent)
				return;
			
			var parent:DisplayObjectContainer = d1.parent;
			
			var isHighIndex:Boolean = parent.getChildIndex(d1) > parent.getChildIndex(d2); 
			var isHighValue:Boolean = d1["priority"] > d2["priority"];
			
			if (isHighIndex != isHighValue)
				parent.swapChildren(d1,d2);
		}
		
		public static function PRIORITY_SORTY(d1:DisplayObject,d2:DisplayObject):void
		{
			if (d1.parent != d2.parent)
				return;
			
			var parent:DisplayObjectContainer = d1.parent;
			
			var isHighIndex:Boolean = parent.getChildIndex(d1) > parent.getChildIndex(d2); 
			var isHighValue:Boolean;
			
			if (d1["priority"] && d2["priority"])
				isHighValue = d1["priority"] > d2["priority"];
			else if (d1["priority"])
				isHighValue = true;
			else if (d2["priority"])
				isHighValue = false;
			else
				isHighValue = d1.y > d2.y;
			
			if (isHighIndex != isHighValue)
				parent.swapChildren(d1,d2);
		}

	}
}