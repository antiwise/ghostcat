package ghostcat.util.encrypt
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	public final class HackChecker
	{
		public static const checkInterval:int = 1000;
		public static var timer:Timer;
		
		private static var prevDate:Number;//上次记录的时间
		private static var prevTime:int;//上次记录的Time
		
		public static function enabledCheckSpeedUp(interval:int = 1000):void
		{
			var nextTime:int = getTimer();
			var interval:int = nextTime - prevTime;
			
			timer = new Timer(interval);
			timer.addEventListener(TimerEvent.TIMER,timeHandler);
			timer.start();
		}
		
		private static function timeHandler(event:TimerEvent):void
		{
			var nextTime:int = getTimer();
			var newDate:Number = new Date().getTime();
			
			var interval:int = nextTime - prevTime;
			
			if (!isNaN(prevDate) && interval - (newDate - prevDate) > 20)
				throw new Error("时间验证出错，请不要使用作弊工具（"+(newDate - prevDate).toString()+"-"+interval.toString()+")");
			
			prevDate = newDate;
			prevTime = nextTime;
		}
	}
}