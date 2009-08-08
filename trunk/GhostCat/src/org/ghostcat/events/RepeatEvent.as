package org.ghostcat.events
{
	import flash.events.Event;
	import flash.geom.Point;

	public class RepeatEvent extends Event
	{
		/**
		 * 增加重复物品
		 */
		public static var ADD_REPEAT_ITEM:String="add_repeat_item";
		/**
		 * 删除重复物品
		 */
		public static var REMOVE_REPEAT_ITEM:String="remove_repeat_item";
		/**
		 * 重复的物品
		 */
		public var repeatObj:*;
		/**
		 * 重复物品在数据中的坐标
		 */
		public var repeatPos:Point;
		public function RepeatEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}