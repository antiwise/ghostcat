package org.ghostcat.util
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
		 * @param completeHandler	完成后方法
		 * @return 
		 * 
		 */
		public static function asynFor(fun:Function,fromValue:int,toValue:int,completeHandler:Function=null):Timer
		{
			var timer:Timer = new Timer(0,int.MAX_VALUE);
			timer.addEventListener(TimerEvent.TIMER,asynHandler);
			return timer;
			
			var i:int = fromValue;
			
			function asynHandler(event:TimerEvent):void
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
			return timer;
			
			function asynHandler(event:TimerEvent):void
			{
				if (!endFun())
					fun()
				else
				{
					timer.removeEventListener(TimerEvent.TIMER,asynHandler);
					timer.stop();
					
					if (completeHandler != null) 
						completeHandler();
				}
			}
		}
	}
}