package org.ghostcat.ui
{
	import flash.display.DisplayObject;
	
	import org.ghostcat.display.IDisplayObject;
	import org.ghostcat.display.IData;

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