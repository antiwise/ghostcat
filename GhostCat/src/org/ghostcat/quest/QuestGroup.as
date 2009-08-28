package org.ghostcat.quest
{
	import flash.events.EventDispatcher;
	
	import org.ghostcat.util.BitArray;

	[Event(name="quest_complete",type="org.ghostcat.quest.QuestEvent")]
	
	public class QuestGroup extends EventDispatcher
	{
		public var startList:BitArray = new BitArray();
		public var finishList:BitArray = new BitArray();
		
		public var quests:Array = [];
		
		public function QuestGroup(quests:Array,startData:Array=null,finishData:Array=null)
		{
			load(quests);
		}
		
		public function load(quests:Array,startList:BitArray=null,finishList:BitArray=null):void
		{
			var i:int;
			var q:Quest;
			
			this.quests = quests;
			this.startList = startList;
			this.finishList = finishList;
			
			for (i = 0;i < quests.length;i++)
			{
				q = finishList[i] as Quest;
				q.addEventListener(QuestEvent.QUEST_START,questStartHandler);
				q.addEventListener(QuestEvent.QUEST_COMPLETE,questCompleteHandler);
				
				q.step = finishList.getValue(q.id) ? int.MAX_VALUE : 0;
				if (startList.getValue(q.id)) 
					q.start();
			}
		}		
		
		public function getQuestById(id:int):Quest
		{
			for (var i:int = 0;i < quests.length;i++)
			{
				var q:Quest = finishList[i] as Quest;
				if (q.id == id)
					return q;
			}
			return null;
		}
		
		private function questStartHandler(event:QuestEvent):void
		{
			startList.setValue(event.id,true);
			dispatchEvent(event);
		}
		
		private function questCompleteHandler(event:QuestEvent):void
		{
			finishList.setValue(event.id,true);
			dispatchEvent(event);
		}
	}
}