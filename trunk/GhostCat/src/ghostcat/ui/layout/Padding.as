package ghostcat.ui.layout
{
	import ghostcat.util.display.Geom;

	/**
	 * 边框数据对象
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class Padding
	{
		public var left:Number;
		public var right:Number;
		public var top:Number;
		public var bottom:Number;
		
		public function Padding(left:Number = NaN,top:Number = NaN,right:Number = NaN,bottom:Number = NaN)
		{
			this.left = left;
			this.right = right;
			this.top = top;
			this.bottom = bottom;
		}
		
		/**
		 * 根据属性更正矩形大小
		 * 
		 * @param rect	需要更正的矩形
		 * @param parent	父矩形
		 * 
		 */
		public function adjectRect(rect:*,parent:*):void
		{
			parent = Geom.getRect(parent,parent);
			
			if (!isNaN(left))
				rect.x = parent.x + left;
			
			if (!isNaN(top))
				rect.y = parent.y + top;
			
			if (!isNaN(right))
				rect.width = parent.right - right - rect.x;
			
			if (!isNaN(right))
				rect.height = parent.bottom - bottom - rect.y;		
		}
		
		/**
		 * 根据更正两个同级矩形的大小
		 * 
		 * @param rect	需要更正的矩形
		 * @param rect2	源矩形
		 * 
		 */
		public function adjectRectBetween(rect:*,rect2:*):void
		{
			if (!isNaN(left))
				rect.x = rect2.x + left;
			
			if (!isNaN(top))
				rect.y = rect2.y + top;
			
			if (!isNaN(right))
				rect.width = rect2.x + rect2.width - right - rect.x;
			
			if (!isNaN(right))
				rect.height = rect2.y + rect2.height - bottom - rect.y;		
		}
		
		/**
		 * 取反
		 * @return 
		 * 
		 */
		public function invent():Padding
		{
			return new Padding(-left,-top,-right,-bottom)
		}
		
		/**
		 * 复制 
		 * @return 
		 * 
		 */
		public function clone():Padding
		{
			return new Padding(left,top,right,bottom)
		}
	}
}