package ghostcat.ui.tooltip
{
	import flash.display.DisplayObject;
	
	import ghostcat.display.IData;
	import ghostcat.display.IDisplayObject;

	/**
	 * 可用于ToolTip的对象皮肤必须实现的接口
	 * 
	 * @author flashyiyi
	 * 
	 */
	public interface IToolTipSkin extends IData,IDisplayObject
	{
		function show(target:DisplayObject):void;
		function positionTo(target:DisplayObject):void;
	}
}