package org.ghostcat.operation
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.ghostcat.events.TickEvent;
	import org.ghostcat.util.Handler;
	import org.ghostcat.util.Tick;

	public class WaitOper extends TimeoutOper
	{
		public var checkHandler:Handler;
		public var interval:Number;
		
		private var timer:Timer;
		
		/**
		 * 重复查看某个条件，条件满足则继续 
		 * 
		 * @param checkHandler	检测的方法，方法返回为true则结束
		 * @param interval	检测间隔。默认则跟随ENTERFRAME发生
		 * 
		 */
		public function WaitOper(checkHandler:Handler,interval:Number=NaN)
		{
			super();
			this.checkHandler = checkHandler;
			this.interval = interval;
		}
		
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
			if (checkHandler.call())
				result();
		}
		
		public override function result(event:*=null):void
		{
			if (timer)
			{
				timer.removeEventListener(TimerEvent.TIMER,tick);
				timer.stop();
				timer = null;
			}
			else
				Tick.instance.removeEventListener(TickEvent.TICK,tick);
			
			super.result(event);
		}
	}
}