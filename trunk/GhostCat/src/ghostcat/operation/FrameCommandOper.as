package ghostcat.operation
{
	import ghostcat.events.TickEvent;
	import ghostcat.util.Tick;
	import ghostcat.util.core.Handler;
	
	[Event(name="tick",type="ghostcat.events.TickEvent")]

	/**
	 * 每帧执行函数
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class FrameCommandOper extends Oper 
	{
		/**
		 * 每次执行的方法 
		 */
		public var onUpdate:Handler;

		/**
		 * 几帧执行一次方法 
		 */
		public var delayedFrame:int;
		
		/**
		 * 重复执行几次方法，负数则为无限重复
		 */
		public var repeatCount:int;
		
		/**
		 * 当前执行帧数 
		 */
		public var frame:int = 0;
		
		/**
		 * 当前执行次数 
		 */
		public var currentCount:int = 0;

		/**
		 * 
		 * @param onUpdate	每次执行的方法 
		 * @param repeatCount	重复执行几次方法，负数则为无限重复
		 * @param delayedFrame	几帧执行一次方法 
		 * 
		 */
		public function FrameCommandOper(onUpdate:*, repeatCount:int = -1, delayedFrame:int = 1)
		{
			if (onUpdate is Function)
				onUpdate = new Handler(onUpdate as Function)
			
			if (delayedFrame < 1)
				delayedFrame = 1;
			
			this.onUpdate = onUpdate;
			this.delayedFrame = delayedFrame;
			this.repeatCount = repeatCount;
		}
		/** @inheritDoc*/
		public override function execute() : void
		{
			super.execute();
			frame = currentCount = 0;
			
			Tick.instance.addEventListener(TickEvent.TICK, tickHandler);
		}
		/** @inheritDoc*/
		protected override function end(event:* = null) : void
		{
			Tick.instance.removeEventListener(TickEvent.TICK, tickHandler);
			super.end();
		}

		/**
		 * 时基事件
		 * @param evt
		 * 
		 */
		protected function tickHandler(evt:TickEvent) : void
		{
			frame++;
			if (frame % delayedFrame == 0)
			{
				currentCount++;
				if (onUpdate != null)
					onUpdate.call();
				
				dispatchEvent(evt);
			}

			if (repeatCount >= 0 && currentCount >= repeatCount)
				result();
		}
	}
}