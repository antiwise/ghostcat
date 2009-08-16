package org.ghostcat.operation
{
	import org.ghostcat.util.Handler;
	
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
		public function FunctionOper(handler:Function,para:Array=null,caller:*=null)
		{
			this.cmd = new Handler(handler,para,caller);
		}
		
		public override function execute():void
		{
			super.execute();
			
			cmd.call();
			result();
		}
		
	}
}