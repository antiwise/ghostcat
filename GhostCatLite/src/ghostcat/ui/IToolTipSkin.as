package ghostcat.ui
{
	import flash.display.DisplayObject;
	
	import ghostcat.core.display.IData;
	import ghostcat.display.IDisplayObject;

	/**
	 * 可用于ToolTip的对象皮肤必须实现的接口
	 * 
	 * @author flashyiyi
	 * 
	 */
	public interface IToolTipSkin extends IData,IDisplayObject
	{
		
		/**
		 * 显示提示
		 * @param target
		 * 
		 */
		function show(target:DisplayObject):void;
		/**
		 * 更新指向位置（每帧更新） 
		 * @param target
		 * 
		 */
		function positionTo(target:DisplayObject):void;
	}
}