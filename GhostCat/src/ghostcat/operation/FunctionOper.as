package ghostcat.operation
{
	import ghostcat.util.core.Handler;
	
	/**
	 * 函数类
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class FunctionOper extends Oper
	{
		public var cmd:Handler;
		
		/**
		 * 执行一个函数
		 *  
		 * @param cmd	函数
		 * 
		 */
		public function FunctionOper(handler:*=null,para:Array=null,caller:*=null)
		{
			
			if (handler is Handler)
				this.cmd =  handler as Handler;
			else
				this.cmd = new Handler(handler,para,caller);
		}
		/** @inheritDoc*/
		public override function execute():void
		{
			super.execute();
			
			cmd.call();
			result();
		}
		
	}
}