package ghostcat.util.core
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * 异步循环方法
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class Asyn
	{
		/**
		 * 执行For
		 * 
		 * @param fun	每个循环节执行的方法
		 * @param fromValue	起始值
		 * @param toValue	结束值
		 * @param repeat	每次执行循环次数
		 * @param completeHandler	完成后方法
		 * @return 
		 * 
		 */
		public static function asynFor(fun:Function,fromValue:int,toValue:int,repeat:int = 1,completeHandler:Function=null):Timer
		{
			var timer:Timer = new Timer(0,int.MAX_VALUE);
			timer.addEventListener(TimerEvent.TIMER,asynHandler);
			
			var i:int = fromValue;
			timer.start();
			return timer;
			
			
			function asynHandler(event:TimerEvent):void
			{
				for (var j:int = 0;j < repeat;j++)
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
		 * @param repeat	每次执行循环次数
		 * @param completeHandler	完成后方法
		 * @return 
		 * 
		 */
		public static function asynWhile(fun:Function,endFun:Function,repeat:int = 1,completeHandler:Function=null):Timer
		{
			var timer:Timer = new Timer(0,int.MAX_VALUE);
			timer.addEventListener(TimerEvent.TIMER,asynHandler);
			timer.start();
			return timer;
			
			function asynHandler(event:TimerEvent):void
			{
				for (var j:int = 0;j < repeat;j++)
				{
					if (!endFun())
						fun()
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