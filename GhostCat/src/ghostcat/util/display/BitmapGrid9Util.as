package ghostcat.util.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.skin.ListBackground;
	import ghostcat.ui.controls.GListBase;
	
	import mx.controls.listClasses.ListBase;

	/**
	 * 位图Grid-9（可以在放大时采用平铺方式）
	 * @author flashyiyi
	 * 
	 */
	public class BitmapGrid9Util
	{
		/**
		 * 通过Grid9算法获得新的位图 
		 * @param source
		 * @param width
		 * @param height
		 * @param scrollRect
		 * @param isTile	采用平铺模式伸展
		 * @return 
		 * 
		 */
		public static function grid9(source:BitmapData,width:Number,height:Number,scrollRect:Rectangle,isTile:Boolean = true):BitmapData
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
			if (isTile)
			{
				//上
				for (i = 0;i < lenx;i++)
					result.copyPixels(source,new Rectangle(scrollRect.x,0,scrollRect.width,scrollRect.y),new Point(scrollRect.x + i * scrollRect.width,0));
				
				//左
				for (i = 0;i < leny;i++)
					result.copyPixels(source,new Rectangle(0,scrollRect.y,scrollRect.x,scrollRect.height),new Point(0,scrollRect.y + i * scrollRect.height));
				
				//中
				for (i = 0;i < leny;i++)
				{
					for (var j:int = 0;j < lenx;j++)
					{
						result.copyPixels(source,scrollRect,new Point(scrollRect.x + j * scrollRect.width,scrollRect.y + i * scrollRect.height));
					}
				}
				
				//下
				for (i = 0;i < lenx;i++)
					result.copyPixels(source,new Rectangle(scrollRect.x,scrollRect.bottom,scrollRect.width,source.height - scrollRect.bottom),new Point(scrollRect.x + i * scrollRect.width,height - (source.height - scrollRect.bottom)));
				
				//右
				for (i = 0;i < leny;i++)
					result.copyPixels(source,new Rectangle(scrollRect.right,scrollRect.y,source.width - scrollRect.right,scrollRect.height),new Point(width - (source.width - scrollRect.right),scrollRect.y + i * scrollRect.height));
			}
			else
			{
				var m:Matrix = new Matrix();
				m.createGradientBox(scrollRect.width,scrollRect.y,0,scrollRect.x,0);
				result.draw(source,m,null,null,new Rectangle(scrollRect.x,0,scrollRect.width,scrollRect.y));
				m.createGradientBox(scrollRect.x,scrollRect.height,0,0,scrollRect.y);
				result.draw(source,m,null,null,new Rectangle(0,scrollRect.y,scrollRect.x,scrollRect.height));
				m.createGradientBox(scrollRect.width,scrollRect.height,0,scrollRect.x,scrollRect.y);
				result.draw(source,m,null,null,scrollRect);
				m.createGradientBox(scrollRect.width,source.height - scrollRect.bottom,0,scrollRect.x,height - (source.height - scrollRect.bottom));
				result.draw(source,m,null,null,new Rectangle(scrollRect.x,scrollRect.bottom,scrollRect.width,source.height - scrollRect.bottom));
				m.createGradientBox(source.width - scrollRect.right,scrollRect.height,0,width - (source.width - scrollRect.right),scrollRect.y);
				result.draw(source,m,null,null,new Rectangle(scrollRect.right,scrollRect.y,source.width - scrollRect.right,scrollRect.height));
			}
			result.copyPixels(source,new Rectangle(0,0,scrollRect.x,scrollRect.y),new Point());
			result.copyPixels(source,new Rectangle(scrollRect.right,0,source.width - scrollRect.right,scrollRect.y),new Point(width - (source.width - scrollRect.right),0));
			result.copyPixels(source,new Rectangle(0,scrollRect.bottom,scrollRect.x,source.height - scrollRect.bottom),new Point(0,height - (source.height - scrollRect.bottom)));
			result.copyPixels(source,new Rectangle(scrollRect.right,scrollRect.bottom,source.width - scrollRect.right,source.height - scrollRect.bottom),new Point(width - (source.width - scrollRect.right),height - (source.height - scrollRect.bottom)));
			return result;
		}
		
		/**
		 * 根据显示对象的大小和ScrollRect自动转换Grid9 
		 * @param target	转换目标，可以是Bitmap或者是包含一个Bitmap的Sprite对象
		 * @param isTile	采用平铺模式伸展
		 */
		public static function autoGrid9(target:DisplayObject,isTile:Boolean = true):void
		{
			if (!target.scrollRect)
				return;
			
			var bitmap:Bitmap;
			if (target is Bitmap)
				bitmap = target as Bitmap;
			else if (target is DisplayObjectContainer)
				bitmap = (target as DisplayObjectContainer).getChildAt(0) as Bitmap;
			
			if (!bitmap)
				return;
			
			var bmd:BitmapData = grid9(bitmap.bitmapData,target.width,target.height,target.scrollRect,isTile);
			bitmap.bitmapData.dispose();
			bitmap.bitmapData = bmd;
			
			target.scaleX = target.scaleY = 1.0;
		}
	}
}