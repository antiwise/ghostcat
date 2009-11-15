package ghostcat.events
{
	import flash.events.Event;
	
	import ghostcat.ui.controls.GText;
	
	/**
	 * GText发生的事件 
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GTextEvent extends Event
	{
		/**
		 * TextField文本变化时发生
		 */
		public static const TEXT_CHANGE:String = "text_change";
		
		public function get control():GText
		{
			return target as GText;
		}
		
		public function GTextEvent(type:String, bubbles:Boolean = true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}