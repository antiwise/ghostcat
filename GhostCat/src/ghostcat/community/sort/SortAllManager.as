package ghostcat.community.sort
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;

	/**
	 * 采用全部排序的方法来处理景深
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class SortAllManager extends EventDispatcher
	{
		public var target:DisplayObjectContainer;
		private var data:Array = [];
		public function SortAllManager(target:DisplayObjectContainer=null)
		{
			this.target = target;
		}
		
		public function refreshChildren():void
		{
			data = [];
			for (var i:int = 0;i < target.numChildren;i++)
				data.push(target.getChildAt(i));
		}
		
		public function calculate(sortFields:Array = null) : void
		{
			if (!target)
				return;
			
			if (!sortFields)
				sortFields = ["y"];
			
			if (!data || data.length != target.numChildren)
				refreshChildren();
			
			var result:Array = data.sortOn(sortFields,Array.NUMERIC|Array.RETURNINDEXEDARRAY);
			for (var i:int = 0; i < result.length; i++)
			{
				var v:DisplayObject = data[result[i]] as DisplayObject;
				target.setChildIndex(v,i);
			}
		}
	}
}