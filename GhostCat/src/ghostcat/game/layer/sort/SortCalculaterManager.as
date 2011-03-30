package ghostcat.game.layer.sort
{
	import flash.display.DisplayObject;
	
	import ghostcat.community.sort.DepthSortUtil;
	import ghostcat.game.item.sort.ISortCalculater;
	import ghostcat.game.layer.GameLayer;
	import ghostcat.util.Util;
	import ghostcat.util.display.BitmapUtil;
	
	/**
	 * 首先通过ISortCalculater对象计算一遍深度，再进行深度排序
	 * 比起使用SortPriorityManager并设置对象的sortCalculater属性的方法，这里每排序一次都需要重新计算深度（无论是否移动），所以只适用运动物体较多的情况
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class SortCalculaterManager extends SortPriorityManager
	{
		public var calculater:ISortCalculater;
		public function SortCalculaterManager(layer:GameLayer, calculater:ISortCalculater)
		{
			super(layer,null);
			this.calculater = calculater;
		}
		
		protected override  function sortFunction(child1:DisplayObject, child2:DisplayObject):Boolean
		{
			calculater.target = child1;
			var v1:int = calculater.calculate();
			calculater.target = child2;
			var v2:int = calculater.calculate();
			
			return v1 < v2;
		}
		
		public override function sortAll():void
		{
			var data:Array = layer.childrenInScreen;
			var depths:Array = [];
			for (var i:int = 0; i < data.length;i++)
			{
				calculater.target = data[i];
				depths[i] = calculater.calculate();
			}
			
			var result:Array = depths.sort(Array.NUMERIC|Array.RETURNINDEXEDARRAY);
			
			if (layer.isBitmapEngine)
			{
				var oldArr:Array = data.concat();
				for (i = 0; i < result.length; i++)
				{
					data[i] = oldArr[result[i]];
				}
			}
			else
			{
				for (i = 0; i < result.length; i++)
				{
					var v:DisplayObject = data[result[i]] as DisplayObject;
					if (v.parent == layer && layer.getChildIndex(v) != i)
						layer.setChildIndex(v,i);
				}
			}
		}
	}
}