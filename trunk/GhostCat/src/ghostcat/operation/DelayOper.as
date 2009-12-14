package ghostcat.operation
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * 延时
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class DelayOper extends Oper
	{
		public function DelayOper(timeout:int = 0)
		{
			this.timeout = timeout;
		}
		/**
		 * 延时时间，毫秒为单位，负数为永久等待
		 */
		public var timeout:int = 0;
		
		private var timer:Timer;
		
		/** @inheritDoc*/
		public override function execute() : void
		{
			super.execute();
			
			if (timeout < 0)
				return;
			
			timer = new Timer(timeout,1)
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,result);
			timer.start();
		}
		
		/** @inheritDoc*/
		protected override function end(event:*=null):void
		{
			super.end(event);
			
			if (timer)
			{
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE,result);
				timer.stop();
			}
		}
	}
}