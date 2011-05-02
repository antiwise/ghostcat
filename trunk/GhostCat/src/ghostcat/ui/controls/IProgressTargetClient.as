package ghostcat.ui.controls
{
	import flash.events.IEventDispatcher;
	
	import ghostcat.operation.IOper;
	
	/**
	 * 能够被GProgress当做source处理需要实现的接口
	 * @author flashyiyi
	 * 
	 */
	public interface IProgressTargetClient extends IEventDispatcher
	{
		function get eventDispatcher():IEventDispatcher;
		function get name():String;
	}
}