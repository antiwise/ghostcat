package ghostcat.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 * 拖动事件
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class DragEvent extends Event
	{
		/**
		 * 开始拖动（可中断）
		 */
		public static const DRAG_START:String="drag_start";
		
		/**
		 * 拖动过程中每帧执行一次
		 */
		public static const DRAG_ON:String="drag_on";
		
		/**
		 * 停止拖动（可中断）
		 */
		public static const DRAG_STOP:String="drag_stop";
		
		/**
		 * 有物品拖动到自己之上
		 */
		public static const DRAG_OVER:String="drag_over";
		
		/**
		 * 有物品拖离自己
		 */
		public static const DRAG_OUT:String="drag_out";
		
		/**
		 * 有物品成功拖到自己身上
		 */
		public static const DRAG_DROP:String="drag_drop";
		
		/**
		 * 自己的拖动操作成功完成
		 */
		public static const DRAG_COMPLETE:String="drag_complete";
		
		/**
		 * 拖动的物品
		 */
		public var dragObj:DisplayObject;
		
		public function DragEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone() : Event
		{
			var evt:DragEvent = new DragEvent(type,bubbles,cancelable);
			evt.dragObj = this.dragObj;
			return evt;
		}
	}
}