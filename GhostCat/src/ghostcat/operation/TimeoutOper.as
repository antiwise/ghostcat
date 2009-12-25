package ghostcat.operation
{
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * 此类增加超时失败功能
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TimeoutOper extends Oper
	{
		/**
		 * 超时时间，毫秒为单位
		 */
		public var timeout:int = 0;
		
		/**
		 * 当这个值为true的时候，时限到达依然执行result方法
		 */
		public var alawaySuccess:Boolean = false;
		
		private var timeId:int;
		/** @inheritDoc*/
		public override function execute() : void
		{
			if (timeout>0)
			{
				if (alawaySuccess)
					timeId = setTimeout(result,timeout);
				else
					timeId = setTimeout(fault,timeout);
			}
		
			super.execute();
		}
		/** @inheritDoc*/
		protected override function end(event:*=null):void
		{
			clearTimeout(timeId);
			
			super.end(event);
		}
	}
}