package ghostcat.display.bitmap
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	/**
	 * 能够被BitmapScreen绘制的对象需要实现的接口
	 * @author tangwei
	 * 
	 */
	public interface IBitmapDataDrawer
	{
		/**
		 * 绘制
		 * @param target
		 * 
		 */
		function drawBitmapData(target:BitmapData):void;
	}
}