package ghostcat.community.command
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import ghostcat.display.viewport.Display45Util;

	/**
	 * 45度角景深排序
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class DrawPriority45Command
	{
		/**
		 * 设置单个格子的大小
		 * @param w
		 * @param h
		 * 
		 */
		public static function setContentSize(w:Number,h:Number):void
		{
			Display45Util.setContentSize(w,h);
		}
		
		/**
		 * 45度角排序
		 *  
		 * @param d1
		 * @param d2
		 * 
		 */
		public static function SORT45(d1:DisplayObject,d2:DisplayObject):Boolean
		{
			if (d1.parent != d2.parent)
				return false;
			
			var parent:DisplayObjectContainer = d1.parent;
			
			if (!parent)
				return false;
			
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