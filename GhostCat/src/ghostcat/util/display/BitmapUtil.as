package ghostcat.util.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.util.ArrayUtil;
	import ghostcat.util.MathUtil;
	
	/**
	 * 位图处理相关方法
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class BitmapUtil
	{
		/**
		 * 绘制一个位图。这个位图能确保容纳整个图像。
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
		 * 切分位图为一组较小的位图
		 * 
		 * @param source
		 * @param width
		 * @param height
		 * @return 
		 * 
		 */
		public static function separateBitmapData(source:BitmapData,width:int,height:int):Array
		{
			var result:Array = [];
			for (var j:int = 0;j < Math.ceil(source.height / height);j++)
			{
				for (var i:int = 0;i < Math.ceil(source.width / width);i++)
				{
					var bitmap:BitmapData = new BitmapData(width,height,true,0);
					bitmap.copyPixels(source,new Rectangle(i*width,j*height,width,height),new Point());
					result.push(bitmap);
				}	
			}
			return result;
		}
		
		/**
		 * 横向拼合位图
		 * 
		 * @param source
		 * @return 
		 * 
		 */
		public static function concatBitmapDataH(source:Array):BitmapData
		{
			
			var width:Number = MathUtil.sum(ArrayUtil.getFieldValues(source,"width"));
			var height:Number = MathUtil.max(ArrayUtil.getFieldValues(source,"height"));
			var result:BitmapData = new BitmapData(width,height,true,0);
			
			var x:int = 0;
			for (var i:int = 0;i < source.length; i++)
			{
				var bitmap:BitmapData = source[i];
				result.copyPixels(bitmap,new Rectangle(0,0,bitmap.width,bitmap.height),new Point(x,0));
				
				x += bitmap.width;
			}	
			return result;
		}
		
		/**
		 * 纵向向拼合位图
		 * 
		 * @param source
		 * @return 
		 * 
		 */
		public static function concatBitmapDataV(source:Array):BitmapData
		{
			
			var width:Number = MathUtil.max(ArrayUtil.getFieldValues(source,"width"));
			var height:Number = MathUtil.sum(ArrayUtil.getFieldValues(source,"height"));
			var result:BitmapData = new BitmapData(width,height,true,0);
			
			var y:int = 0;
			for (var i:int = 0;i < source.length; i++)
			{
				var bitmap:BitmapData = source[i];
				result.copyPixels(bitmap,new Rectangle(0,0,bitmap.width,bitmap.height),new Point(0,y));
				
				y += bitmap.width;
			}	
			return result;
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
		public static function scale(source:BitmapData,scaleX:Number =1.0,scaleY:Number = 1.0):BitmapData
		{
			var result:BitmapData = new BitmapData(source.width * scaleX,source.height * scaleY,true,0);
			var m:Matrix = new Matrix();
			m.scale(scaleX,scaleY);
			result.draw(source,m);
			return result;
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
					(item as Bitmap).bitmapData.dispose();
			}
		}
	}
}