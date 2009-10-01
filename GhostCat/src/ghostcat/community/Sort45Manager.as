package ghostcat.community
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	import ghostcat.display.GBase;

	/**
	 * 针对45度景深排序做了优化
	 * @author flashyiyi
	 * 
	 */
	public class Sort45Manager extends SortYManager
	{
		/** @inheritDoc*/
		protected override function getDeepOffest(g:GBase):Number
		{
			if (g.position.equals(g.oldPosition))
				return 0;
			
			var d1:Point = g.position;
			var d2:Point = g.oldPosition;
			
			var p1:Point = new Point(d1.x + d1.y * wh,d1.y - d1.x/wh)
			var p2:Point = new Point(d2.x + d2.y * wh,d2.y - d2.x/wh)
			return (p1.x > p2.x || p1.y > p2.y) ? 1 : -1;
			return g.y - g.oldPosition.y;
		}
		
		private var wh:Number = 1;
		
		/**
		 * 设置单个格子的大小
		 * @param w
		 * @param h
		 * 
		 */
		public function setContentSize(w:Number,h:Number):void
		{
			wh = w / h;
		}
		/** @inheritDoc*/
		protected override function sortCommand(d1:DisplayObject,d2:DisplayObject):Boolean
		{
			if (d1.parent != d2.parent)
				return false;
			
			var parent:DisplayObjectContainer = d1.parent;
			
			var i1:int = parent.getChildIndex(d1);
			var i2:int = parent.getChildIndex(d2);
			var isHighIndex:Boolean = i1 > i2; 
			var p1:Point = new Point(d1.x + d1.y * wh,d1.y - d1.x/wh)
			var p2:Point = new Point(d2.x + d2.y * wh,d2.y - d2.x/wh)
			var isHighValue:Boolean = p1.x > p2.x || p1.y > p2.y;
			
			if (isHighIndex != isHighValue)
			{
				parent.setChildIndex(d1,i2);
				return true;
			};
			return false;
		}
	}
}