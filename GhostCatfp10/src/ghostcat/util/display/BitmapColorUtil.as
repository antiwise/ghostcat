package ghostcat.util.display
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * 位图颜色处理
	 * @author flashyiyi
	 * 
	 */
	public final class BitmapColorUtil
	{
		/**
		 * 获得一个位图的平均颜色
		 * 
		 * @param source	位图源
		 * @return 
		 * 
		 */
		public static function getAvgColor(source:BitmapData):uint
		{
			var m:Matrix = new Matrix();
			m.scale(1/source.width,1/source.height);
			var bitmap:BitmapData = new BitmapData(1,1,true,0);
			bitmap.draw(source,m);
			var c:uint = bitmap.getPixel32(0,0);
			bitmap.dispose();
			return c;
		}
		
		/**
		 * 将一个不透明的位图设置某个透明色并返回透明位图
		 * 
		 * @param source	位图源
		 * @param c	32位颜色值
		 * 
		 */
		public static function getTransparentBitmapData(source:BitmapData,transparentColor:uint=0xFFFFFFFF):BitmapData
		{
			var result:BitmapData = new BitmapData(source.width,source.height,true,0);
			result.threshold(source,source.rect,new Point(),"==",transparentColor,0,0xFFFFFFFF,true);
			return result;
		}
		
		/**
		 * 取左上角颜色设置为透明色
		 * @param source	位图源
		 * @return 
		 * 
		 */
		public static function getTransparentBitmapDataByLeftTop(source:BitmapData):BitmapData
		{
			return getTransparentBitmapData(source,source.getPixel32(0,0));
		}
		
		/**
		 * 魔术套索
		 *  
		 * @param source
		 * @param x
		 * @param y
		 * @param offest	取色容错范围
		 * @param near	是否连续
		 * @return 返回的是一个白色位图，非透明区域即是选择区域
		 * 
		 */
		public static function magicPole(source:BitmapData,x:int,y:int,offest:int = 0,near:Boolean = true):BitmapData
		{
			var c:uint = source.getPixel32(x,y);
			var c1:uint = offestColor(c,-offest);
			var c2:uint = offestColor(c,offest);
			var temp:BitmapData = new BitmapData(source.width,source.height,true,0xFFFFFFFF);
			temp.threshold(source,source.rect,new Point(),"<",c1,0x0);
			temp.threshold(source,source.rect,new Point(),">",c2,0x0);
			if (near)
			{
				temp.floodFill(x,y,0xFFFF0000);
				temp.threshold(temp,temp.rect,new Point(),"!=",0xFFFF0000,0x0);
				temp.colorTransform(temp.rect,new ColorTransform(1,1,1,1,0,255,255));
			}
			return temp;
		}
		
		private static function offestColor(rgb:uint, brite:Number):uint
		{
			var a:Number = (rgb >> 24) & 0xFF;
			var r:Number = Math.max(Math.min(((rgb >> 16) & 0xFF) + brite, 255), 0);
			var g:Number = Math.max(Math.min(((rgb >> 8) & 0xFF) + brite, 255), 0);
			var b:Number = Math.max(Math.min((rgb & 0xFF) + brite, 255), 0);
			
			return (a << 24) | (r << 16) | (g << 8) | b;;
		} 
	}
}