package ghostcat.operation
{
	/**
	 * 此类增加失败重试功能
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class RetryOper extends TimeoutOper
	{
		/**
		 * 最大重试次数
		 */
		public var maxRetry:int = 3;
		
		/**
		 * 目前重试次数
		 */
		public var retry:int = 0;
		
		/** @inheritDoc*/
		public override function fault(event:*=null) : void
		{
			if (retry < maxRetry)
			{
				execute();
				retry++;
			}
			else
				super.fault(event);
		}
	}
}