package org.ghostcat.bitmap
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.ghostcat.util.ArrayUtil;
	import org.ghostcat.util.MathUtil;
	
	/**
	 * 位图处理相关方法
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class BitmapUtil
	{
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
		 * 马赛克
		 * 
		 * @param source
		 * @param scaleX
		 * @param scaleY
		 * @return 
		 * 
		 */
		public static function mosaic(source:BitmapData,width:int = 1.0,height:int = 1.0):BitmapData
		{
			var result:BitmapData = source.clone();
			var wl:int = source.width / width;
			var hl:int = source.height / height;
			for (var j:int = 0;j < hl;j++)
			{
				for (var i:int = 0;i < wl;i++)
				{
					var rect:Rectangle = new Rectangle(i*width,j*height,width,height);
					result.fillRect(rect,getAvgColor(source,rect));
				}
			}
			return result;
		}
		
		/**
		 * 获得位图的平均颜色
		 * 
		 * @param source
		 * @param rect
		 * @return 
		 * 
		 */
		public static function getAvgColor(source:BitmapData,rect:Rectangle=null):uint
		{
			if (!rect)
				rect = new Rectangle(0,0,source.width,source.height);
			
			var ar:Number = 0;
			var ag:Number = 0;
			var ab:Number = 0;
			for (var j:int = rect.top;j < rect.bottom;j++)
			{
				for (var i:int = rect.left;i < rect.right;i++)
				{
					var rgb:uint = source.getPixel(i,j);
					ar += (rgb >> 16) & 0xFF;
					ag += (rgb >> 8) & 0xFF;
					ab += rgb & 0xFF;
				}
			}
			var p:Number = rect.width * rect.height;
			return (int(ar/p) << 16) | (int(ag/p) << 8) | int(ab/p);
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
	}
}