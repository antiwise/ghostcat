package org.ghostcat.util
{
	/**
	 * 函数执行器 
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class Handler
	{
		public var caller:*;
		public var handler:Function;
		public var para:Array;
		
		private var _toFunction:Function;
		/**
		 * 函数执行器
		 * 
		 * @param handler	函数
		 * @param para	参数数组
		 * @param caller	调用者
		 * 
		 */
		public function Handler(handler:Function,para:Array=null,caller:*=null)
		{
			this.handler = handler;
			this.para = para;
			this.caller = caller;
		}
		
		/**
		 * 调用
		 * @return 
		 * 
		 */
		public function call() : *
		{
			return (this.handler as Function).apply(this.caller,this.para);
		}
		
		/**
		 * 转换成Function
		 * @return 
		 * 
		 */
		public function toFunction():Function
		{
			if (_toFunction==null)
				_toFunction = function (...parameters):*{return call()};
			return _toFunction;	
		
		}
		/**
		 * 销毁
		 * 
		 */
		public function destory():void
		{
			_toFunction = null;
		}
	}
}