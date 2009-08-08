package org.ghostcat.events
{
	import flash.events.Event;
	import flash.text.TextField;
	
	public class TextFieldEvent extends Event
	{
		public static const TEXT_CHANGE:String = "text_change";
		
		public var textField:TextField;
		
		public function TextFieldEvent(type:String, bubbles:Boolean = true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}