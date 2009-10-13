package ghostcat.display.bitmap
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Point;
	
	/**
	 * 能够被BitmapScreen绘制的对象需要实现的接口
	 * @author tangwei
	 * 
	 */
	public interface IBitmapDataDrawer
	{
		/**
		 * 采用copyPixel绘制到位图上
		 * @param target
		 * 
		 */
		function drawToBitmapData(target:BitmapData):void;
		/**
		 * 采用beginBitmapFill绘制到图形上
		 * @param target
		 * 
		 */
		function drawToShape(target:Graphics):void;
		
		/**
		 * 检查鼠标当前点，并返回接受事件的对象
		 * @param pos
		 * @return 
		 * 
		 */
		function checkMouseEvent(pos:Point):IBitmapDataDrawer;
	}
}