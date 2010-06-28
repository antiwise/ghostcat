package ghostcat.util
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 * 扩展的Timer，会修正省电模式Timer次数减少的问题
	 * @author flashyiyi
	 * 
	 */
	public class SleepTimer extends Timer
	{
		private var prevTimer:int;
		
		public var onTimer:Function;
		public var onTimerComplete:Function;
		
		public function SleepTimer(delay:Number, repeatCount:int=0, onTimer:Function = null, onTimerComplete:Function = null)
		{
			super(delay, repeatCount);
			this.onTimer = onTimer;
			this.onTimerComplete = onTimerComplete;
		}
		
		public override function start():void
		{
			this.addEventListener(TimerEvent.TIMER,timerHandler);
			this.addEventListener(TimerEvent.TIMER_COMPLETE,timerCompleteHandler);
			
			this.prevTimer = getTimer();
			
			super.start();
		}
		
		protected function timerHandler(event:TimerEvent):void
		{
			while (getTimer() - prevTimer >= delay)
			{
				prevTimer += delay;
				
				if (onTimer!=null)
					onTimer();
			}
		}
		
		protected function timerCompleteHandler(event:TimerEvent):void
		{
			this.removeEventListener(TimerEvent.TIMER,timerHandler);
			this.removeEventListener(TimerEvent.TIMER_COMPLETE,timerCompleteHandler);
			
			if (onTimerComplete!=null)
				onTimerComplete();
		}
	}
}