package ghostcat.ui.layout
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.ui.UIConst;
	import ghostcat.util.Geom;
	
	/**
	 * 布局方法
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class LayoutUtil
	{
		/**
		 * 对齐
		 * 
		 * @param obj
		 * @param container
		 * @param horizontalAlign
		 * @param verticalAlign
		 * 
		 */
		public static function silder(obj:*,container:*,horizontalAlign:String = null,verticalAlign:String = null):void
		{
			var cRect:Rectangle = Geom.getRect(container,container);
			var rect:Rectangle = Geom.getRect(obj,container);
			var offest:Point = new Point(obj.x - rect.x,obj.y - rect.y);
			switch (horizontalAlign)
			{
				case UIConst.LEFT:
					obj.x = cRect.x + offest.x;
					break;
				case UIConst.CENTER:
					obj.x = cRect.x + (cRect.width - rect.width)/2 + offest.x;
					break;
				case UIConst.RIGHT:
					obj.x = cRect.x + (cRect.width - rect.width) + offest.x;
					break;
			}
			switch (verticalAlign)
			{
				case UIConst.TOP:
					obj.y = cRect.y + offest.y;
					break;
				case UIConst.MIDDLE:
					obj.y = cRect.y + (cRect.height - rect.height)/2 + offest.y;
					break;
				case UIConst.BOTTOM:
					obj.y = cRect.y + (cRect.height - rect.height) + offest.y;
					break;
			}
		}
		
		/**
		 * 从中部偏移
		 * 
		 * @param obj
		 * @param container
		 * @param horizontalCenter
		 * @param verticalCenter
		 * 
		 */
		public static function center(obj:*,container:*,horizontalCenter:Number = NaN,verticalCenter:Number = NaN):void
		{
			var cRect:Rectangle = Geom.getRect(container,container);
			var rect:Rectangle = Geom.getRect(obj,container);
			var offest:Point = new Point(obj.x - rect.x,obj.y - rect.y);
			
			if (!isNaN(horizontalCenter))
				obj.x = cRect.x + (cRect.width - rect.width)/2 + offest.x + horizontalCenter;
			
			if (!isNaN(verticalCenter))
				obj.y = cRect.y + (cRect.height - rect.height)/2 + offest.y + verticalCenter;
			
		}
		
		/**
		 * 控制外框边距
		 * 
		 * @param obj
		 * @param container
		 * @param left
		 * @param right
		 * @param top
		 * @param bottom
		 * @return 
		 * 
		 */
		public static function metrics(obj:*,container:*,left:Number=NaN,top:Number=NaN,right:Number=NaN,bottom:Number=NaN):void
		{
			var cRect:Rectangle = Geom.getRect(container,container);
			var rect:Rectangle = Geom.getRect(obj,container);
			var offest:Point = new Point(obj.x - rect.x,obj.y - rect.y);
			
			if (!isNaN(left))
				obj.x = cRect.x + left + offest.x;
			
			if (!isNaN(top))
				obj.y = cRect.y + top + offest.y;
			
			if (!isNaN(right))
			{
				if (!isNaN(left))
				{
					
					obj.width = cRect.right - (obj.x - offest.x) - right;
					obj.x -= offest.x * (1 - obj.width / rect.width);
				}
				else
					obj.x = cRect.right - rect.width + offest.x;
			}
			
			if (!isNaN(bottom))
			{
				if (!isNaN(top))
				{
					obj.height = cRect.bottom - (obj.y - offest.y) - bottom;
					obj.y -= offest.y * (1 - obj.height / rect.height);
				}
				else
					obj.y = cRect.bottom - rect.height + offest.y;
			}
		}
		
		/**
		 * 百分比长宽
		 * 
		 * @param obj
		 * @param container
		 * @param width
		 * @param height
		 * 
		 */
		public static function percent(obj:*,container:*,width:Number=NaN,height:Number=NaN):void
		{
			if (!isNaN(width))
				obj.width = container.width * width;
			
			if (!isNaN(height))
				obj.height = container.height * height;
		}
		
		/**
		 * 横向排列
		 * 
		 * @param obj
		 * @param prev	上一个物品
		 * @param gap	间距
		 * 
		 */
		public static function horizontal(obj:*,prev:*,container:*,gap:int = 0):void
		{
			var pRect:Rectangle = Geom.getRect(prev,container);
			var rect:Rectangle = Geom.getRect(obj,container);
			var offest:Point = new Point(obj.x - rect.x,obj.y - rect.y);
			
			obj.x = pRect.right + offest.x + gap;
		}
		
		/**
		 * 纵向排列
		 * 
		 * @param obj
		 * @param prev	上一个物品
		 * @param gap	间距
		 * 
		 */
		public static function vertical(obj:*,prev:*,container:*,gap:int = 0):void
		{
			var pRect:Rectangle = Geom.getRect(prev,container);
			var rect:Rectangle = Geom.getRect(obj,container);
			var offest:Point = new Point(obj.x - rect.x,obj.y - rect.y);
			
			obj.y = pRect.bottom + offest.y + gap;
		
		}
	}
}