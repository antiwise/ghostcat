package ghostcat.util.core
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import ghostcat.events.TickEvent;
	import ghostcat.util.Tick;

	/**
	 * 延迟调用函数集中管理器 
	 * @author flashyiyi
	 * 
	 */
	public class CallLaterQueue
	{
		static public var instance:CallLaterQueue = new CallLaterQueue();
		
		private var timer:Timer;
		private var timeQueue:Array;
		
		private var ticker:Tick;
		private var tickQueue:Array;
		
		public function CallLaterQueue():void
		{
			this.timer = new Timer(0);
			this.timer.addEventListener(TimerEvent.TIMER,timerHandler);
			this.timeQueue = [];
			
			this.ticker = Tick.instance;
			this.ticker.addEventListener(TickEvent.TICK,tickHandler);
			this.tickQueue = [];
		}
		
		public function callLaterByTime(f:Function):void
		{
			timeQueue[timeQueue.length] = f;
			if (!timer.running)
			{
				timer.repeatCount = 1;
				timer.start();
			}
		}
		
		public function callLaterByTick(f:Function):void
		{
			tickQueue[tickQueue.length] = f;
		}
		
		private function timerHandler(event:TimerEvent):void
		{
			for each (var f:Function in timeQueue)
				f();
			
			timeQueue.length = 0;
		}
		
		private function tickHandler(event:TickEvent):void
		{
			for each (var f:Function in tickQueue)
				f();
			
			tickQueue.length = 0;
		}
	}
}