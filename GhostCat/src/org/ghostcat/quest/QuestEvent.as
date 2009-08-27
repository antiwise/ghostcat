package org.ghostcat.quest
{
	import flash.events.Event;
	
	public class QuestEvent extends Event
	{
		public static const QUEST_START:String = "quest_start"
		public static const QUEST_COMPLETE:String = "quest_complete"
		
		public var id:int;
		
		public function QuestEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}