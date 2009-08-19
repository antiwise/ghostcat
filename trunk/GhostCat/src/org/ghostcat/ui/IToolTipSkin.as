package org.ghostcat.ui
{
	import flash.display.DisplayObject;
	
	import org.ghostcat.core.IDisplayObject;
	import org.ghostcat.display.IData;

	/**
	 * 可用于ToolTip的对象需要实现的接口
	 * 
	 * @author flashyiyi
	 * 
	 */
	public interface IToolTipSkin extends IData,IDisplayObject
	{
		function setTarget(target:DisplayObject):void;
	}
}