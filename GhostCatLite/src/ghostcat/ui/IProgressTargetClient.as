package ghostcat.ui
{
	import flash.events.IEventDispatcher;
	/**
	 * 能够被GProgress处理需要实现的接口
	 * @author flashyiyi
	 * 
	 */
	public interface IProgressTargetClient extends IEventDispatcher
	{
		function get eventDispatcher():IEventDispatcher;
		function get name():String;
	}
}