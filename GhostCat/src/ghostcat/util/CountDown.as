package ghostcat.util
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * 此类是一个增强功能的Timer。用来解决Timer使用步骤繁琐的问题。
	 * 为了简化代码，它对事件采用了弱引用，因此不能像Timer那样保持对象的引用，这点需要特别注意。
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class CountDown extends EventDispatcher
	{
		private var countDowns:Object;
		
		private static var _defaultCountDown:CountDown;
		
		/**
		 * 默认计时器
		 */		
		public static function get defaultCountDown():CountDown
		{
			if (!_defaultCountDown)
				_defaultCountDown = new CountDown();
			return _defaultCountDown;
		}
		
		public function CountDown()
		{
			countDowns = new Object();
		}
		
		/**
		 * 获取Timer
		 * 
		 * @param name	名称
		 * @return 
		 * 
		 */		
		public function getCountDown(name:String):Timer
		{
			return countDowns[name];
		}
		
		/**
		 * 添加Timer
		 * 
		 * @param name	名称
		 * @param loop	循环次数
		 * @param interval	发布间隔
		 * @param timeHander	每次事件
		 * @param completeHandler	结束事件
		 * 
		 */		
		public function addCountDown(name:String,loop:int,interval:int,timeHander:Function=null,completeHandler:Function=null):void
		{
			removeCountDown(name);
			
			var timer:Timer = new Timer(interval,loop);
			timer.addEventListener(TimerEvent.TIMER,timeHander,false,0,true);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,completeHandler,false,0,true);
			
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,destoryHandler);
			timer.start();
			
			countDowns[name] = timer;
		}
		
		private function destoryHandler(event:TimerEvent):void
		{
			var timer:Timer = event.currentTarget as Timer;
			removeCountDown(getCountDownName(timer));
		}
		
		/**
		 * 删除Timer
		 * 
		 * @param name	名称
		 * 
		 */		
		public function removeCountDown(name:String):void
		{
			var timer:Timer = getCountDown(name);
			if (!timer)
				return;
			
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE,destoryHandler);
			timer.stop();
			
			delete countDowns[name];
		}
		
		/**
		 * 延迟Timer
		 * 
		 * @param name	名称
		 * @param interval	间隔
		 * 
		 */		
		public function resetCountDown(name:String,interval:int):void
		{
			var timer:Timer = getCountDown(name);
			if (timer)
				timer.delay = interval;
		}
		
		/**
		 * 返回Timer在类里的名称
		 * 
		 * @param timer	Timer对象
		 * @return 
		 * 
		 */
		public function getCountDownName(timer:Timer):String
		{
			for (var key:* in countDowns)
			{
				if (countDowns[key] == timer)
					return key.toString();
			}
			return null;
		}
		
		/**
		 * 销毁方法
		 * 
		 */		
		public function destroy():void
		{
			for (var name:* in countDowns){
				removeCountDown(name);
			}
		}
	}
}