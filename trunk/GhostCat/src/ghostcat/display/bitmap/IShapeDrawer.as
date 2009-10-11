package ghostcat.display.bitmap
{
	import flash.display.Graphics;
	
	/**
	 * 能够被ShapeScreen绘制的对象需要实现的接口
	 * @author tangwei
	 * 
	 */
	public interface IShapeDrawer
	{
		/**
		 * 绘制
		 * @param target
		 * 
		 */
		function drawToShape(target:Graphics):void;
	}
}