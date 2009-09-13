package ghostcat.operation.quest
{
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	import ghostcat.util.BitArray;

	[Event(name="quest_start",type="ghostcat.operation.quest.QuestEvent")]
	[Event(name="quest_complete",type="ghostcat.operation.quest.QuestEvent")]
	
	public class QuestGroup extends EventDispatcher
	{
		public var startList:BitArray;
		public var finishList:BitArray;
		
		public var quests:Array = [];
		
		public function get stepList():Array
		{
			var result:Array = [];
			for (var i:int = 0;i < quests.length;i++)
				result.push((quests[i] as Quest).step)
			
			return result;
		}
		
		public function QuestGroup()
		{
			startList = new BitArray();
			finishList = new BitArray();
		}
		
		public function load(quests:Array,startList:BitArray=null,finishList:BitArray=null,stepList:Array=null):void
		{
			this.quests = quests;
			this.startList = startList;
			this.finishList = finishList;
			
			for (var i:int = 0;i < quests.length;i++)
			{
				var q:Quest = quests[i] as Quest;
				q.addEventListener(QuestEvent.QUEST_START,questStartHandler);
				q.addEventListener(QuestEvent.QUEST_COMPLETE,questCompleteHandler);
				
				if (stepList)
					q.step = stepList[i];
					
				if (startList.getValue(q.id)) 
					q.start();
			}
		}	
		
		public function loadFromByteArray(quests:Array,bytes:ByteArray):void
		{
			var i:int;
			var arr:Array;
			var len:int = bytes.readUnsignedInt();
			arr = [];
			for (i = 0;i < len;i++)
				arr.push(bytes.readUnsignedInt());
			
			var startList:BitArray = new BitArray();
			startList.createFromIntArray(arr);
			
			len = bytes.readUnsignedInt();
			arr = [];
			for (i = 0;i < len;i++)
				arr.push(bytes.readUnsignedInt());
			
			var finishList:BitArray = new BitArray();
			finishList.createFromIntArray(arr);
			
			len = bytes.readUnsignedInt();
			var stepList:Array = [];
			for (i = 0;i < len;i++)
				stepList.push(bytes.readUnsignedInt());
			
			load(quests,startList,finishList,stepList);
		}	
		
		public function getByteArray():ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			var arr:Array;
			var i:int;
			arr = startList.toIntArray();
			bytes.writeUnsignedInt(arr.length);
			for (i = 0;i < arr.length;i++)
				bytes.writeUnsignedInt(arr[i]);
			
			arr = finishList.toIntArray();
			bytes.writeUnsignedInt(arr.length);
			for (i = 0;i < arr.length;i++)
				bytes.writeUnsignedInt(arr[i]);
			
			arr = stepList.concat();
			bytes.writeUnsignedInt(arr.length);
			for (i = 0;i < arr.length;i++)
				bytes.writeUnsignedInt(arr[i]);
			
			return bytes;
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
		
		public function destory():void
		{
			for each (var q:Quest in quests)
				q.destory();
		}
	}
}