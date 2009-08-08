package org.ghostcat.events
{
	import flash.events.Event;
	
	public class GEvent extends Event
	{
		public static const UPDATE_COMPLETE:String = "update_complete";
		
		public function GEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}