package org.ghostcat.events
{
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * TextField发生的事件 
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TextFieldEvent extends Event
	{
		/**
		 * TextField文本变化时发生
		 */
		public static const TEXT_CHANGE:String = "text_change";
		
		public var textField:TextField;
		
		public function TextFieldEvent(type:String, bubbles:Boolean = true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}