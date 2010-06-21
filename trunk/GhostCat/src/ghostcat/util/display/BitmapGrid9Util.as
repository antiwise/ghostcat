package ghostcat.util.display
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.skin.ListBackground;
	import ghostcat.ui.controls.GListBase;
	
	import mx.controls.listClasses.ListBase;

	/**
	 * 位图Grid-9（放大时采用平铺方式）
	 * @author flashyiyi
	 * 
	 */
	public class BitmapGrid9Util
	{
		public static function grid9(source:BitmapData,width:Number,height:Number,scrollRect:Rectangle):BitmapData
		{
			var right:int = width - scrollRect.right;
			var bottom:int = height - scrollRect.bottom;
			var result:BitmapData = new BitmapData(width,height,source.transparent,0);
			var i:int;
			var len:int;
			var dx:int = width - scrollRect.x - (source.width - scrollRect.right);
			var dy:int = height - scrollRect.y - (source.height - scrollRect.bottom);
			var lenx:int = Math.ceil(dx / scrollRect.width);
			var leny:int = Math.ceil(dy / scrollRect.height);
			for (i = 0;i < lenx;i++)
			{
				result.copyPixels(source,new Rectangle(scrollRect.x,0,scrollRect.width,scrollRect.y),new Point(scrollRect.x + i * scrollRect.width,0));
			}
			for (i = 0;i < leny;i++)
			{
				result.copyPixels(source,new Rectangle(0,scrollRect.y,scrollRect.x,scrollRect.height),new Point(0,scrollRect.y + i * scrollRect.height));
			}
			for (i = 0;i < leny;i++)
			{
				for (var j:int = 0;j < lenx;j++)
				{
					result.copyPixels(source,scrollRect,new Point(scrollRect.x + j * scrollRect.width,scrollRect.y + i * scrollRect.height));
				}
			}
			for (i = 0;i < lenx;i++)
			{
				result.copyPixels(source,new Rectangle(scrollRect.x,scrollRect.bottom,scrollRect.width,source.height - scrollRect.bottom),new Point(scrollRect.x + i * scrollRect.width,height - (source.height - scrollRect.bottom)));
			}
			for (i = 0;i < leny;i++)
			{
				result.copyPixels(source,new Rectangle(scrollRect.right,scrollRect.y,source.width - scrollRect.right,scrollRect.height),new Point(width - (source.width - scrollRect.right),scrollRect.y + i * scrollRect.height));
			}
			result.copyPixels(source,new Rectangle(0,0,scrollRect.x,scrollRect.y),new Point());
			result.copyPixels(source,new Rectangle(scrollRect.right,0,source.width - scrollRect.right,scrollRect.y),new Point(width - (source.width - scrollRect.right),0));
			result.copyPixels(source,new Rectangle(0,scrollRect.bottom,scrollRect.x,source.height - scrollRect.bottom),new Point(0,height - (source.height - scrollRect.bottom)));
			result.copyPixels(source,new Rectangle(scrollRect.right,scrollRect.bottom,source.width - scrollRect.right,source.height - scrollRect.bottom),new Point(width - (source.width - scrollRect.right),height - (source.height - scrollRect.bottom)));
			return result;
		}
	}
}