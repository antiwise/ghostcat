package ghostcat.ui
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	

	public final class LayoutUtil
	{
		public static function silder(obj:DisplayObject,container:DisplayObjectContainer,horizontalAlign:String,verticalAlign:String):void
		{
			var cRect:Rectangle = container.getRect(container);
			var rect:Rectangle = obj.getRect(container);
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
		
	}
}