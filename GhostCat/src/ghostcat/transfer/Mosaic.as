package ghostcat.transfer
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	public class Mosaic extends GBitmapTransfer
	{
		public function Mosaic()
		{
			super();
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
	}
}