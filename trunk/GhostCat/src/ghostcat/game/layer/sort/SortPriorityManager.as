package ghostcat.game.layer.sort
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import ghostcat.community.sort.DepthSortUtil;
	import ghostcat.game.item.sort.ISortCalculater;
	import ghostcat.game.layer.BitmapGameLayer;
	import ghostcat.game.layer.GameLayerBase;
	import ghostcat.util.display.BitmapUtil;
	
	public class SortPriorityManager extends EventDispatcher implements ISortManager
	{
		public var sortFields:Array;
		public function SortPriorityManager(sortFields:Array = null)
		{
			this.sortFields = sortFields ? sortFields : ["priority"];
			super();
		}
		
		public function sort(layer:GameLayerBase,child:*):void
		{
			
		}
		
		public function sortAll(layer:GameLayerBase):void
		{
			if (layer.isBitmapEngine)
			{
				layer.childrenInScreen.sortOn(sortFields,Array.NUMERIC);
			}
			else
			{
				var data:Array = layer.childrenInScreen;
				var result:Array = data.sortOn(sortFields,Array.NUMERIC|Array.RETURNINDEXEDARRAY);
				
				for (var i:int = 0; i < result.length; i++)
				{
					var v:DisplayObject = data[result[i]] as DisplayObject;
					if (v.parent == layer && layer.getChildIndex(v) != i)
						layer.setChildIndex(v,i);
				}
			}
		}
	}
}