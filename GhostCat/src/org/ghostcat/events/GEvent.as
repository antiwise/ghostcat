package org.ghostcat.events
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
		public static const UPDATE_COMPLETE:String = "update_complete";
		
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