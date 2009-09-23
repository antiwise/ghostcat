package ghostcat.display
{
	/**
	 * GBase接口 
	 * 
	 * @author flashyiyi
	 * 
	 */
	public interface IGBase extends IDisplayObject,IData,ICursorManagerClient,IToolTipManagerClient
	{
		/**
		 * 在之后更新坐标
		 */
		function invalidatePosition():void
		
		/**
		 * 在之后更新大小
		 */
		function invalidateSize():void
		
		/**
		 * 在之后更新显示
		 */
		function invalidateDisplayList():void
		
		/**
		 * 更新坐标并发事件
		 */
		function vaildPosition(noEvent:Boolean = false):void
		
		/**
		 * 更新大小并发事件 
		 */
		function vaildSize(noEvent:Boolean = false):void
		
		/**
		 * 更新显示并发事件 
		 */
		function vaildDisplayList(noEvent:Boolean = false):void
	}
}