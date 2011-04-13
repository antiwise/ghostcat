package ghostcat.util.core
{
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	/**
	 * 异步循环方法
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class Asyn
	{
		/**
		 * 执行间隔毫秒数，应当是一个小于1000/帧频的值
		 */
		public static var asynInv:int = 10;
		
		/**
		 * 自动设置执行间隔 
		 * 
		 * @param stage	舞台实例
		 * @param idleTime	空闲时间
		 * @return 
		 * 
		 */
		public static function autoSetInv(stage:Stage,idleTime:int = 5):int
		{
			asynInv = 1000/stage.frameRate - idleTime;
			return asynInv;
		}
		
		/**
		 * 执行For
		 * 
		 * @param fun	每个循环节执行的方法
		 * @param fromValue	起始值
		 * @param toValue	结束值
		 * @param completeHandler	完成后方法
		 * @return 
		 * 
		 */
		public static function asynFor(fun:Function,fromValue:int,toValue:int,completeHandler:Function=null):Timer
		{
			var timer:Timer = new Timer(0,int.MAX_VALUE);
			timer.addEventListener(TimerEvent.TIMER,asynHandler);
			
			var i:int = fromValue;
			timer.start();
			return timer;
			
			
			function asynHandler(event:TimerEvent):void
			{
				var t:int = getTimer();
				while (getTimer() - t < asynInv)
				{
					if (i < toValue)
					{
						fun(i);
						i++;
					}
					else
					{
						timer.removeEventListener(TimerEvent.TIMER,asynHandler);
						timer.stop();
						
						if (completeHandler != null) 
							completeHandler();
						
						break;
					}
				}
			}
		}
		
		/**
		 * 执行While
		 * 
		 * @param fun	每个循环节执行的方法
		 * @param endFun	此函数返回false时结束循环
		 * @param completeHandler	完成后方法
		 * @return 
		 * 
		 */
		public static function asynWhile(fun:Function,endFun:Function,completeHandler:Function=null):Timer
		{
			var timer:Timer = new Timer(0,int.MAX_VALUE);
			timer.addEventListener(TimerEvent.TIMER,asynHandler);
			timer.start();
			return timer;
			
			function asynHandler(event:TimerEvent):void
			{
				var t:int = getTimer();
				while (getTimer() - t < asynInv)
				{
					if (!endFun())
					{
						fun()
					}
					else
					{
						timer.removeEventListener(TimerEvent.TIMER,asynHandler);
						timer.stop();
						
						if (completeHandler != null) 
							completeHandler();
						
						break;
					}
				}
			}
		}
	}
}