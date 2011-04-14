package ghostcat.debug
{
	import flash.utils.getTimer;

	/**
	 * 速度测试
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class SpeedTester
	{
		/**
		 * 重复执行一个方法检测速度
		 * 
		 * @param metord
		 * @param repeat
		 * 
		 */
		public static function testMetord(metord:Function,repeat:int = 100000):void
		{
			var i:int;
			var t1:int,t2:int,t3:int,t4:int;
			
			t1 = getTimer();
			for (i = 0;i < repeat;i++);
			t2 = getTimer();
			for (i = 0;i < repeat;i++)
				emptyHandler();
			t3 = getTimer();
			for (i = 0;i < repeat;i++)
				metord();
			t4 = getTimer();
			
			var d1:int = t2 - t1
			var d2:int = t3 - t2;
			var d3:int = t4 - t3;
			trace("测试结果：" + (d3 - d2) + "ms ("+ ((d3 - d2)/(d2 - d1)).toFixed(1) +")")
		}
		
		private static var t:int = -1;
		private static var baseTime:int;
		
		/**
		 * 测试开始
		 * 
		 */
		public static function testStart():void
		{
			var t1:int,t2:int;
			t1 = getTimer();
			for (var i:int = 0;i < 100000;i++)
				emptyHandler();
			t2 = getTimer();
			baseTime = t2 - t1;
			
			t = getTimer();
		}
		
		/**
		 * 测试结束
		 * 
		 */
		public static function testEnd():void
		{
			if (t == -1)
				return;
			
			var result:int = getTimer() - t;
			t = -1;
			
			trace("测试结果：" + result +"ms (" + (result/baseTime).toFixed(2) + ")")
		}
		
		private static function emptyHandler():void
		{
		}
	}
}