package ghostcat.util.sleep
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import ghostcat.display.movieclip.TimeLine;

	/**
	 * 检测是否睡眠 
	 * @author flashyiyi
	 * 
	 */
	public class SleepCheck
	{
		static public var onSleep:Function;
		static public var onWake:Function;
		static public var isSleep:Boolean;
		
		static private var timer:Timer;
		static private var t:int;
		
		public static function start(onSleep:Function = null,onWake:Function = null):void
		{
			if (timer)
				stop();
			
			SleepCheck.onSleep = onSleep;
			SleepCheck.onWake = onWake;
			
			timer = new Timer(10,uint.MAX_VALUE);
			timer.addEventListener(TimerEvent.TIMER,timeHandler);
			timer.start();
			
			t = getTimer();
		}
		
		public static function stop():void
		{
			SleepCheck.onSleep = null;
			SleepCheck.onWake = null;
			
			if (timer)
			{
				timer.removeEventListener(TimerEvent.TIMER,timeHandler);
				timer.stop();
				timer = null;
			}
			
			t = 0;
		}
		
		private static function timeHandler(event:TimerEvent):void
		{
			if (getTimer() - t >= 100 && !isSleep)
			{
				isSleep = true;
				if (onSleep != null)
					onSleep();
			}
			else if (getTimer() - t < 100 && isSleep)
			{
				isSleep = false;
				
				if (onWake != null)
					onWake();
			}
		}
	}
}