package ghostcat.community.sort
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import ghostcat.community.GroupManager;
	import ghostcat.display.viewport.Display45Util;

	/**
	 * 采用全部排序的方法来处理景深
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class SortAllManager extends GroupManager
	{
		public static const SORT_Y:Array = ["y"];
		
		public static const SORT_45:Function = Display45Util.SORT_45;
		
		public var sortFields:*;
		
		public function SortAllManager(sortFields:*)
		{
			this.sortFields = sortFields;
			super();
		}
		
		/**
		 * 排序
		 * @param sortFields	排序依据
		 * 
		 */
		public override function calculateAll(onlyFilter:Boolean = true) : void
		{
			if (!container)
				return;
			
			var result:Array;
			if (sortFields is Array) 
				result = data.sortOn(sortFields,Array.NUMERIC|Array.RETURNINDEXEDARRAY);
			else if (sortFields is Function)
				result = data.sort(sortFields,Array.NUMERIC|Array.RETURNINDEXEDARRAY);
			else
				return;
				
			for (var i:int = 0; i < result.length; i++)
			{
				var v:DisplayObject = data[result[i]] as DisplayObject;
				if (v.parent == container && container.getChildIndex(v) != i)
					container.setChildIndex(v,i);
			}
		}
	}
}