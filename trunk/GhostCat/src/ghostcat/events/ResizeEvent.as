package ghostcat.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * 缩放事件 
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ResizeEvent extends Event
	{
		/**
		 * 大小变化 
		 */
		public static const RESIZE:String = "resize";
		
		/**
		 * 子对象大小变化
		 */
		public static const CHILD_RESIZE:String = "child_resize"
		
		/**
		 * 缩放前的大小
		 */
		public var oldSize:Point;
		/**
		 * 缩放后新的大小
		 */
		public var size:Point;
		
		/**
		 * 变化大小的子对象
		 */
		public var child:DisplayObject;
		
		public function ResizeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone() : Event
		{
			var evt:ResizeEvent = new ResizeEvent(type,bubbles,cancelable);
			evt.oldSize = this.oldSize;
			evt.size = this.size;
			evt.child = this.child;
			return evt;
		}
	}
}