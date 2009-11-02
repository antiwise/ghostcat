package ghostcat.util.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.util.ArrayUtil;
	import ghostcat.util.MathUtil;

	public final class BitmapSeparateUtil
	{
		/**
		 * 切分位图为一组较小的位图
		 * 
		 * @param source
		 * @param width
		 * @param height
		 * @param toBitmap	转换为Bitmap
		 * @return 
		 * 
		 */
		public static function separateBitmapData(source:BitmapData,width:int,height:int,toBitmap:Boolean = false):Array
		{
			var result:Array = [];
			for (var j:int = 0;j < Math.ceil(source.height / height);j++)
			{
				for (var i:int = 0;i < Math.ceil(source.width / width);i++)
				{
					var bitmap:BitmapData = new BitmapData(width,height,true,0);
					bitmap.copyPixels(source,new Rectangle(i*width,j*height,width,height),new Point());
					if (toBitmap)
					{
						var bp:Bitmap = new Bitmap(bitmap);
						bp.x = i * width;
						bp.y = j * height;
						result.push(bp);
					}
					else
						result.push(bitmap)
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
				
				y += bitmap.height;
			}	
			return result;
		}
		
		/**
		 * 在一个限定的宽度内拼合位图
		 * 
		 * @param source	位图数据源
		 * @param maxWidth	最大宽度
		 * @param resultRect	结果矩形区域数据
		 * @return 
		 * 
		 */
		public static function concatBitmapDataLimitWidth(source:Array,maxWidth:int,resultRects:Array = null):BitmapData
		{
			if (!resultRects)
				resultRects = [];
			
			var x:int = 0;
			var y:int = 0;
			var mh:int = 0;
			for (var i:int = 0;i < source.length;i++)
			{
				var bitmap:BitmapData = source[i];
				if (x + bitmap.width <= maxWidth)
				{
					if (bitmap.height > mh)
						mh = bitmap.height;
				}
				else
				{
					x = 0;
					y += mh;
					mh = 0;
				}
				resultRects.push(new Rectangle(x,y,bitmap.width,bitmap.height))
				x += bitmap.width;
			}
			
			var result:BitmapData = new BitmapData(maxWidth,y + mh,true,0);
			
			for (i = 0;i < resultRects.length;i++)
			{
				bitmap = source[i];
				result.copyPixels(bitmap,bitmap.rect,(resultRects[i] as Rectangle).topLeft);
			}
			
			return result;
		}
	}
}