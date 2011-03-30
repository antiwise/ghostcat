package ghostcat.game.layer.sort
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	import ghostcat.display.game.Display45Util;
	import ghostcat.game.layer.GameLayer;
	import ghostcat.game.layer.sort.client.ISortHitTestClient;
	
	/**
	 * 以物体坐标是否在障碍之上为依据排序，获得障碍范围需要让物品实现ISortHitTestClient
	 * @author flashyiyi
	 * 
	 */
	public class SortHitTestManager extends SortPriorityManager
	{
		public function SortHitTestManager(layer:GameLayer)
		{
			super(layer, sortHitTestFunction);
		}
		
		private function sortHitTestFunction(v1:DisplayObject,v2:DisplayObject):int
		{
			var b1:BitmapData = v1 is ISortHitTestClient ? ISortHitTestClient(v1).sortBitmapData : null;
			var b2:BitmapData = v2 is ISortHitTestClient ? ISortHitTestClient(v2).sortBitmapData : null;
			if (!b1 && !b2 || b1 && b2)
			{
				return v1.y > v2.y ? 1 : v1.y < v2.y ? -1 : 0
			}
			else
			{
				if (b1)
				{
					return b1.getPixel32(v2.x - v1.x, v2.y - v1.y) > 0 ? 1 : -1;
				}
				else
				{
					return b2.getPixel32(v1.x - v2.x, v1.y - v2.y) > 0 ? -1 : 1;
				}
			}
			return 0;
		}
	}
}