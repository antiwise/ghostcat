package ghostcat.operation
{
	public interface IOper
	{
		/**
		 * 立即执行
		 * 
		 */		
		function execute():void
		
		/**
		 * 成功函数
		 * 
		 */		
		function result(event:*=null):void
		
		/**
		 * 失败函数
		 * 
		 */		
		function fault(event:*=null):void
		
		/**
		 * 推入队列
		 * 
		 * @param queue	使用的队列，为空则为默认队列
		 * 
		 */
		function commit(queue:Queue = null):void
		
		/**
		 * 中断队列 
		 * 
		 */
		function halt():void
	}
}