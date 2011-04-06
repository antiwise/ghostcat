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
		private var timeQueuePara:Array;
		
		private var ticker:Tick;
		private var tickQueue:Array;
		private var tickQueuePara:Array;
		
		public function CallLaterQueue():void
		{
			this.timer = new Timer(0,1);
			this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,timerHandler);
			this.timeQueue = [];
			this.timeQueuePara = [];
			
			this.ticker = Tick.instance;
			this.ticker.addEventListener(TickEvent.TICK,tickHandler);
			this.tickQueue = [];
			this.tickQueuePara = [];
		}
		
		public function callLaterByTime(f:Function,para:Array = null):void
		{
			timeQueue[timeQueue.length] = f;
			timeQueuePara[timeQueuePara.length] = para;
			if (!timer.running)
			{
				timer.repeatCount = 1;
				timer.start();
			}
		}
		
		public function callLaterByTick(f:Function,para:Array = null):void
		{
			tickQueue[tickQueue.length] = f;
			tickQueuePara[tickQueuePara.length] = para;
		}
		
		private function timerHandler(event:TimerEvent):void
		{
			var list:Array = timeQueue.concat();
			var listPara:Array = timeQueuePara.concat();
			timeQueue.length = 0;
			timeQueuePara.length = 0;
			
			var l:int = list.length;
			for (var i:int = 0;i < l;i++)
			{
				var para:Array = listPara[i];
				if (para)
					(list[i] as Function).apply(null,listPara[i]);
				else
					(list[i] as Function)();
			}
		}
		
		private function tickHandler(event:TickEvent):void
		{
			var list:Array = tickQueue.concat();
			var listPara:Array = tickQueuePara.concat();
			tickQueue.length = 0;
			tickQueuePara.length = 0;
			
			var l:int = list.length;
			for (var i:int = 0;i < l;i++)
			{
				var para:Array = listPara[i];
				if (para)
					(list[i] as Function).apply(null,listPara[i]);
				else
					(list[i] as Function)();
			}
			
		}
	}
}