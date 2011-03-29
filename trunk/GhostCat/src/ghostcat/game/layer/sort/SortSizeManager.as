package ghostcat.game.layer.sort
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.game.layer.GameLayer;
	import ghostcat.game.layer.sort.client.ISortSizeClient;
	import ghostcat.util.display.Geom;
	
	/**
	 * 根据底面边框排序 
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
			var r1:Rectangle = v1 is ISortSizeClient ? ISortSizeClient(v1).sortRect.clone() : new Rectangle();
			var r2:Rectangle = v2 is ISortSizeClient ? ISortSizeClient(v2).sortRect.clone() : new Rectangle();
			r1.offset(p1.x,p1.y);
			r2.offset(p2.x,p2.y);
			var d:int = (r1.right <= r2.left ? 0 : r1.left >= r2.right ? 2 : 1) +
				(r1.bottom <= r2.top ? 0 : r1.top >= r2.bottom ? 6 : 3);
			if (d > 4)
				return 1;
			else if (d < 4)
				return -1;
			else
				return v1.y > v2.y ? 1 : v1.y < v2.y ? -1 : 0;
		}
	}
}