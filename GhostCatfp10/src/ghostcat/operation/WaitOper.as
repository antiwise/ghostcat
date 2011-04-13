package ghostcat.operation
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import ghostcat.events.TickEvent;
	import ghostcat.util.Tick;
	import ghostcat.util.core.Handler;

	/**
	 * 重复查看某个条件，条件满足则继续 
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class WaitOper extends TimeoutOper
	{
		/**
		 * 检测函数
		 */
		public var checkHandler:Handler;
		
		/**
		 * 检测间隔
		 */
		public var interval:Number;
		
		/**
		 * 成功条件 
		 */
		public var value:*;
		
		/**
		 * 限定值的類型
		 */
		public var type:Class;
		
		/**
		 * 當返回為false時繼續 
		 */
		public var invent:Boolean = false;
		
		private var timer:Timer;
		
		/**
		 * 重复查看某个条件，条件满足则继续 
		 * 
		 * @param checkHandler	检测的方法，方法返回为true则结束
		 * @param interval	检测间隔。默认则跟随ENTERFRAME发生
		 * @param value	结束需要的结果，默认返回非空即结束
		 * @param invent 當返回為false時繼續
		 * 
		 */
		public function WaitOper(checkHandler:*=null,interval:Number=NaN,value:* = null,type:Class = null,invent:Boolean = false)
		{
			super();
			
			if (checkHandler is Handler)
				this.checkHandler = checkHandler as Handler;
			else
				this.checkHandler = new Handler(checkHandler)
			
			this.interval = interval;
			this.invent = invent;
			this.type = type;
			this.value = value;
		}
		
		/** @inheritDoc*/
		public override function execute() : void
		{
			super.execute();
			
			if (interval)
			{
				timer = new Timer(interval,int.MAX_VALUE);
				timer.addEventListener(TimerEvent.TIMER,tick);
				timer.start();
			}
			else
			{
				Tick.instance.addEventListener(TickEvent.TICK,tick,false,0,false);
			}
		}
		
		private function tick(event:Event):void
		{
			var r:* = checkHandler.call();
			var b:Boolean = (value == null && r || value != null && value == r)
			
			if (type != null && !(r is type))
				b = false;
				
			if (invent != b)
				result();
		}
		
		/** @inheritDoc*/
		protected override function end(event:*=null):void
		{
			super.end(event);
			
			if (timer)
			{
				timer.removeEventListener(TimerEvent.TIMER,tick);
				timer.stop();
				timer = null;
			}
			else
				Tick.instance.removeEventListener(TickEvent.TICK,tick);
		}
	}
}