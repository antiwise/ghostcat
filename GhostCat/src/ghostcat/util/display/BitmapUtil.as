package ghostcat.util.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 位图处理相关方法
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class BitmapUtil
	{
		/**
		 * 绘制并创建一个位图。这个位图能确保容纳整个图像。
		 * 
		 * @param displayObj
		 * @return 
		 * 
		 */
		public static function drawToBitmap(displayObj:DisplayObject):BitmapData
		{
			var rect:Rectangle = displayObj.getBounds(displayObj);
			var m:Matrix = new Matrix();
			m.translate(-rect.x,-rect.y);
			var bitmap:BitmapData = new BitmapData(rect.width,rect.height,true,0);
			bitmap.draw(displayObj,m);
			return bitmap;
		}
		
		/**
		 * 用绘制的位图替换原来的显示对象，保持原来的坐标 
		 * @param displayObj
		 * @return 
		 * 
		 */
		public static function replaceWithBitmap(displayObj:DisplayObject,pixelSnapping:String = "auto",smoothing:Boolean = false):Bitmap
		{
			var bitmap:Bitmap = new Bitmap(drawToBitmap(displayObj),pixelSnapping,smoothing);
			var rect:Rectangle = displayObj.getBounds(displayObj);
			bitmap.x = displayObj.x + rect.x;
			bitmap.y = displayObj.y + rect.y;
			return bitmap;
		}
		
		/**
		 * 缩放绘制位图填充某个区域 
		 * @param source
		 * @param target
		 * @param targetRect
		 * @param smoothing 平滑
		 */
		public static function drawToRectangle(source:IBitmapDrawable,target:BitmapData,targetRect:Rectangle,smoothing:Boolean = false):void
		{
			var m:Matrix = new Matrix();
			m.createBox(targetRect.width / source["width"],targetRect.height / source["height"],0,targetRect.x,targetRect.y);
			target.draw(source,m,null,null,null,smoothing);
		}
		
		/**
		 * 缩放BitmapData
		 * 
		 * @param source
		 * @param scaleX
		 * @param scaleY
		 * @return 
		 * 
		 */
		public static function scale(source:BitmapData,scaleX:Number =1.0,scaleY:Number = 1.0,disposeSource:Boolean = true):BitmapData
		{
			var result:BitmapData = new BitmapData(source.width * scaleX,source.height * scaleY,source.transparent);
			var m:Matrix = new Matrix();
			m.scale(scaleX,scaleY);
			result.draw(source,m);
			if (disposeSource)
				source.dispose()
			return result;
		}
		
		/**
		 * 水平翻转
		 */
		public static function flipH(source:BitmapData,disposeSource:Boolean = true):BitmapData
		{
			var result:BitmapData = new BitmapData(source.width,source.height,source.transparent);
			var m:Matrix = new Matrix();
			m.a = -m.a;
			result.draw(source,m);
			if (disposeSource)
				source.dispose()
			return result;
		}
		
		/**
		 * 垂直翻转
		 */		
		public static function flipV(source:BitmapData,disposeSource:Boolean = true):BitmapData
		{
			var result:BitmapData = new BitmapData(source.width,source.height,source.transparent);
			var m:Matrix = new Matrix();
			m.d = -m.d;
			result.draw(source,m);
			if (disposeSource)
				source.dispose()
			return result;
		}
		
		/**
		 * 截取BitmapData
		 * 
		 * @param source
		 * @param clipRect
		 * @return 
		 * 
		 */
		public static function clip(source:BitmapData,clipRect:Rectangle,disposeSource:Boolean = true):BitmapData
		{
			var result:BitmapData = new BitmapData(clipRect.width,clipRect.height,source.transparent);
			result.copyPixels(source,clipRect,new Point());
			if (disposeSource)
				source.dispose()
			return result;
		}
		
		/**
		 * 获得位图有像素的范围
		 * 
		 * @param source
		 * @return 
		 * 
		 */
		public static function getSoildRect(source:BitmapData):Rectangle
		{
			var mask:BitmapData = source.clone();
			mask.threshold(mask,mask.rect,new Point(),">",0,0xFFFFFFFF,0xFFFFFFFF);
			var clipRect:Rectangle = mask.getColorBoundsRect(0xFFFFFFFF,0xFFFFFFFF,true);
			mask.dispose();
			
			return clipRect;
		}
		
		/**
		 * 清除位图内容 
		 * 
		 * @param source
		 * 
		 */
		public static function clear(source:BitmapData):void
		{
			source.fillRect(source.rect,0);
		}
		
		/**
		 * 获取位图的非透明区域，可以用来做图片按钮的hitArea区域
		 * 
		 * @param source	图像源
		 * @return 
		 * 
		 */
		public static function getMask(source:BitmapData):Shape
		{
			var s:Shape = new Shape();
			s.graphics.beginFill(0);
			for(var i:int = 0;i < source.width;i++)
			{
				for(var j:int = 0;j < source.height;j++)
				{
					if (source.getPixel32(i,j))
						s.graphics.drawRect(i,j,1,1);
				}
			}
			s.graphics.endFill();
			return s;
		}
		
		/**
		 * 回收一个数组内所有的BitmapData
		 *  
		 * @param bitmapDatas
		 * 
		 */
		public static function dispose(items:Array):void
		{
			for each (var item:* in items)
			{
				if (item is BitmapData)
					(item as BitmapData).dispose();
					
				if (item is Bitmap)
				{
					(item as Bitmap).bitmapData.dispose();
					if ((item as Bitmap).parent)
						(item as Bitmap).parent.removeChild(item as Bitmap);
				}
			}
		}
	}
}