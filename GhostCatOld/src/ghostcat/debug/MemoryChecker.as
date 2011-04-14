package ghostcat.debug
{
	import flash.system.System;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	/**
	 * 内存检测类
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class MemoryChecker
	{
		static private var checkMemoryIntervalID:uint;
		static private var showWarning:Boolean = true;//是否已发出过警告信息
		
		/**
		 * 内存不足警告范围
		 */
		static public var warningMemory:uint = 50 << 20;
		/**
		 * 内存不足警告执行的方法
		 */
		static public var warningHandler:Function;
		/**
		 * 内存不足关闭程序的范围
		 */
		static public var abortMemory:uint = 75 << 20;
		/**
		 * 内存不足关闭程序执行的方法
		 */
		static public var abortHandler:Function;
		
		/**
		 * 开始检测
		 * @param interval
		 * 
		 */
		static public function start(interval:int = 10000):void
		{
			checkMemoryIntervalID = setInterval(checkMemoryUsage,interval);
		}
		
		/**
		 * 停止检测
		 * 
		 */		
		static public function stop():void
		{
			clearInterval(checkMemoryIntervalID);
		}
		
		static private function checkMemoryUsage():void
		{
			if (warningHandler!=null && System.totalMemory > warningMemory && showWarning) 
			{
				showWarning = false; 
				warningHandler();
			}
			else if (abortHandler!=null && System.totalMemory > abortMemory)
				abortHandler();
		}
	}
}