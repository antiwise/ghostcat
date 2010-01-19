package ghostcat.events
{
	import flash.events.Event;
	
	/**
	 * GhostCat基本组建事件
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GEvent extends Event
	{
		/**
		 * 更新事件
		 */
		public static const UPDATE_COMPLETE:String = "update_complete";
		
		/**
		 * 创建完毕
		 */
		public static const CREATE_COMPLETE:String = "create_complete";
		
		/**
		 * 显示事件（可中断）
		 */
		public static const SHOW:String = "show";
		
		/**
		 * 隐藏事件（可中断）
		 */
		public static const HIDE:String = "hide";
		
		/**
		 * 数据变化
		 */
		public static const DATA_CHANGE:String = "data_change";
		
		/**
		 * 执行destory方法时触发的事件（可中断，若是直接被removeChild，即使触发了这个事件也无法中断了）
		 */
		public static const REMOVE:String = "remove";
		
		public function GEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone() : Event
		{
			var evt:GEvent = new GEvent(type,bubbles,cancelable);
			return evt;
		}
	}
}