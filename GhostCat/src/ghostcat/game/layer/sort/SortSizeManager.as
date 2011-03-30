package ghostcat.game.layer.sort
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.game.layer.GameLayer;
	import ghostcat.game.layer.sort.client.ISortSizeClient;
	import ghostcat.util.display.Geom;
	
	/**
	 * 根据底面边框排序，获得边框需要让物品实现ISortSizeClient
	 * @author flashyiyi
	 * 
	 */
	public class SortSizeManager extends SortPriorityManager
	{
		/**
		 * 是否按45度角排序
		 */
		public var is45:Boolean;
		/**
		 * 45度方块长宽比
		 */
		public var wh:Number = 2.0;
		
		public function SortSizeManager(layer:GameLayer)
		{
			super(layer, sortSizeFunction);
		}
		
		private function sortSizeFunction(v1:DisplayObject,v2:DisplayObject):int
		{
			var p1:Point = is45 ? new Point(v1.x + v1.y * wh, v1.y - v1.x / wh) : new Point(v1.x, v1.y);
			var p2:Point = is45 ? new Point(v1.x + v1.y * wh, v1.y - v1.x / wh) : new Point(v2.x, v2.y);
			
			var x1:int = p1.x;
			var y1:int = p1.y;
			var l1:int = p1.x;
			var b1:int = p1.y;;
			
			var x2:int = p2.x;
			var y2:int = p2.y;
			var l2:int = p2.x;
			var b2:int = p2.y;;
			
			var r1:Rectangle = v1 is ISortSizeClient ? ISortSizeClient(v1).sortRect : null;
			var r2:Rectangle = v2 is ISortSizeClient ? ISortSizeClient(v2).sortRect : null;
			
			if (r1)
			{
				x1 += r1.x;
				y1 += r1.y;
				l1 += r1.x + r1.width;
				b1 += r1.y + r1.height;
			}
			
			if (r2)
			{
				x2 += r2.x;
				y2 += r2.y;
				l2 += r2.x + r2.width;
				b2 += r2.y + r2.height;
			}
			
			var d:int = (l1 <= x2 ? 0 : x1 >= l2 ? 2 : 1) + (b1 <= y2 ? 0 : y1 >= b2 ? 6 : 3);
			if (d > 4)
				return 1;
			else if (d < 4)
				return -1;
			else
				return v1.y > v2.y ? 1 : v1.y < v2.y ? -1 : 0;
		}
	}
}