package ghostcat.ui
{
	import flash.display.DisplayObject;
	
	import ghostcat.display.IDisplayObject;
	import ghostcat.display.IData;

	/**
	 * 可用于ToolTip的对象皮肤必须实现的接口
	 * 
	 * @author flashyiyi
	 * 
	 */
	public interface IToolTipSkin extends IData,IDisplayObject
	{
		function positionTo(target:DisplayObject):void;
	}
}