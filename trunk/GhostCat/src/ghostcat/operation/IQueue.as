package ghostcat.operation
{
	public interface IQueue extends IOper
	{
		/**
		 * 推入队列
		 * 
		 */			
		function commitChild(obj:Oper):void
		
		/**
		 * 移出队列
		 * 
		 */
		function haltChild(obj:Oper):void
	}
}