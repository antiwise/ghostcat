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
		
		public var gText:GText;
		
		public function GTextEvent(type:String, bubbles:Boolean = true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone() : Event
		{
			var evt:GTextEvent = new GTextEvent(type,bubbles,cancelable);
			evt.gText = this.gText;
			return evt;
		}
	}
}