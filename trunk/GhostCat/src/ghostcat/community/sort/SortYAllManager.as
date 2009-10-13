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
	public class SortYAllManager extends EventDispatcher
	{
		public var target:DisplayObjectContainer;
		private var data:Array = [];
		public function SortYAllManager(target:DisplayObjectContainer=null)
		{
			this.target = target;
		}
		
		public function refreshChildren():void
		{
			data = [];
			for (var i:int = 0;i < target.numChildren;i++)
				data.push(target.getChildAt(i));
		}
		
		public function calculate() : void
		{
			if (!target)
				return;
			
//			if (!data || data.length != target.numChildren)
			refreshChildren();
			
			var result:Array = data.sortOn(["y"],Array.NUMERIC|Array.RETURNINDEXEDARRAY);
			for (var i:int = 0; i < data.length; i++)
			{
				var index:int = result.indexOf(i);
				var v:DisplayObject = data[index] as DisplayObject;
				target.setChildIndex(v,i);
			}
		}
	}
}