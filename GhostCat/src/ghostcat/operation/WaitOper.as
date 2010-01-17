package ghostcat.operation
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import ghostcat.events.TickEvent;
	import ghostcat.util.Tick;
	import ghostcat.util.core.Handler;

	/**
	 * 重复查看某个条件，条件满足则继续 
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class WaitOper extends TimeoutOper
	{
		/**
		 * 检测函数
		 */
		public var checkHandler:Handler;
		
		/**
		 * 检测间隔
		 */
		public var interval:Number;
		
		/**
		 * 成功条件 
		 */
		public var value:*;
		
		private var timer:Timer;
		
		/**
		 * 重复查看某个条件，条件满足则继续 
		 * 
		 * @param checkHandler	检测的方法，方法返回为true则结束
		 * @param interval	检测间隔。默认则跟随ENTERFRAME发生
		 * @param value	结束需要的结果，默认返回非空即结束
		 * 
		 * 
		 */
		public function WaitOper(checkHandler:*=null,interval:Number=NaN,value:* = null)
		{
			super();
			
			if (checkHandler is Handler)
				this.checkHandler = checkHandler as Handler;
			else
				this.checkHandler = new Handler(checkHandler)
			
			this.interval = interval;
			this.value = value;
		}
		
		/** @inheritDoc*/
		public override function execute() : void
		{
			super.execute();
			
			if (interval)
			{
				timer = new Timer(interval,int.MAX_VALUE);
				timer.addEventListener(TimerEvent.TIMER,tick);
				timer.start();
			}
			else
			{
				Tick.instance.addEventListener(TickEvent.TICK,tick);
			}
		}
		
		private function tick(event:Event):void
		{
			var r:* = checkHandler.call();
			if (value == null && r || value != null && value == r)
				result();
		}
		
		/** @inheritDoc*/
		protected override function end(event:*=null):void
		{
			super.end(event);
			
			if (timer)
			{
				timer.removeEventListener(TimerEvent.TIMER,tick);
				timer.stop();
				timer = null;
			}
			else
				Tick.instance.removeEventListener(TickEvent.TICK,tick);
		}
	}
}