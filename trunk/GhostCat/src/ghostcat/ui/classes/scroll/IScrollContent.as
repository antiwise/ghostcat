package ghostcat.ui.classes.scroll
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;

	[Event(name="scroll",type="flash.events.Event")]
	
	/**
	 * 滚动容器接口
	 * @author flashyiyi
	 * 
	 */
	public interface IScrollContent extends IEventDispatcher
	{
		/**
		 * 目标
		 * @return 
		 * 
		 */
		function get content():DisplayObject;
		
		/**
		 * 最大横向范围
		 * @return 
		 * 
		 */
		function get maxScrollH():int
		/**
		 * 最大纵向范围
		 * @return 
		 * 
		 */
		function get maxScrollV():int
		/**
		 * 横向滚动坐标
		 * @return 
		 * 
		 */
		function get scrollH():int
		function set scrollH(v:int):void
		/**
		 * 纵向滚动坐标
		 * @return 
		 * 
		 */
		function get scrollV():int
		function set scrollV(v:int):void
	}
}