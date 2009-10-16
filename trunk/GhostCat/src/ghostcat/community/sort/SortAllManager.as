package ghostcat.community.sort
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import ghostcat.display.viewport.Display45Util;

	/**
	 * 采用全部排序的方法来处理景深
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class SortAllManager extends EventDispatcher
	{
		public static const SORT_Y:Array = ["y"];
		
		public static const SORT_45:Function = Display45Util.SORT_45;
		
		/**
		 * 全部对象所在的容器
		 */
		public var target:DisplayObjectContainer;
		/**
		 * 子对象列表
		 */
		public var data:Array = [];
		
		public function SortAllManager(target:DisplayObjectContainer=null)
		{
			this.target = target;
		}
		
		/**
		 * 刷新子对象列表
		 * 
		 */
		public function refreshChildren():void
		{
			data = [];
			for (var i:int = 0;i < target.numChildren;i++)
				data.push(target.getChildAt(i));
		}
		
		/**
		 * 排序
		 * @param sortFields	排序依据
		 * 
		 */
		public function calculate(sortFields:* = null) : void
		{
			if (!target)
				return;
			
			if (!sortFields)
				sortFields = SORT_Y;
			
			if (!data || data.length != target.numChildren)
				refreshChildren();
			
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
				if (target.getChildIndex(v) != i)
					target.setChildIndex(v,i);
			}
		}
	}
}