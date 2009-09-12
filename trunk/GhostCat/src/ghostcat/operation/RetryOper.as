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
		public var maxRetry:int = 3;
		public var retry:int = 0;
		
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