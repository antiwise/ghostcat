package ghostcat.events
{
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * Repeater类的专用事件
	 * 
	 * @author flashyiyi
	 * 
	 */
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
		 * 物品
		 */
		public var repeatObj:*;
		
		/**
		 * 重复物品在数据中的坐标
		 */
		public var repeatPos:Point;
		
		/**
		 * 物品被添加时是否是被添加到底层
		 */
		public var addToLow:Boolean = false;
		
		/**
		 * 在Tile容器中的索引
		 */
		public var repeatIndex:int;
		
		public function RepeatEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone() : Event
		{
			var evt:RepeatEvent = new RepeatEvent(type,bubbles,cancelable);
			evt.repeatObj = this.repeatObj;
			evt.repeatPos = this.repeatPos;
			evt.addToLow = this.addToLow;
			evt.repeatIndex = this.repeatIndex;
			return evt;
		}
		
	}
}