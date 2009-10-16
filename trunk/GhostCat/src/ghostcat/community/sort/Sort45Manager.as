package ghostcat.community.sort
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	import ghostcat.display.IGBase;
	import ghostcat.display.viewport.Display45Util;

	/**
	 * 针对45度景深排序做了优化
	 * @author flashyiyi
	 * 
	 */
	public class Sort45Manager extends SortYManager
	{
		/** @inheritDoc*/
		protected override function getDeepOffest(g:IGBase):Number
		{
			if (g.position.equals(g.oldPosition))
				return 0;
			
			return Display45Util.SORT_45(g.position,g.oldPosition);
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
			var isHighValue:Boolean = Display45Util.SORT_45(d1,d2) > 0;
			
			if (isHighIndex != isHighValue)
			{
				parent.setChildIndex(d1,i2);
				return true;
			};
			return false;
		}
	}
}