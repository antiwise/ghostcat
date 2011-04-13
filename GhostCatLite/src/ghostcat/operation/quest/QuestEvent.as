package ghostcat.operation.quest
{
	import flash.events.Event;
	
	/**
	 * 任务事件
	 * @author flashyiyi
	 * 
	 */
	public class QuestEvent extends Event
	{
		/**
		 * 任务开始
		 */
		public static const QUEST_START:String = "quest_start"
		/**
		 * 任务完成
		 */
		public static const QUEST_COMPLETE:String = "quest_complete"
		
		/**
		 * 任务id 
		 */
		public var id:int;
		
		public function QuestEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}