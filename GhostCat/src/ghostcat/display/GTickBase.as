package ghostcat.display
{
	import ghostcat.events.TickEvent;
	import ghostcat.util.Tick;

	/**
	 * 拥有时基的对象
	 *  
	 * @author flashyiyi
	 * 
	 */
	public class GTickBase extends GBase
	{
		public function GTickBase(skin:*=null, replace:Boolean=true)
		{
			super(skin, replace);
			Tick.instance.addEventListener(TickEvent.TICK,tickHandler);
		}
		
		/**
		 * 是否暂停
		 * @return 
		 */	
		public override function set paused(v:Boolean):void
		{
			if (super.paused == v)
				return;
				
			if (v)
				Tick.instance.removeEventListener(TickEvent.TICK,tickHandler);
			else
				Tick.instance.addEventListener(TickEvent.TICK,tickHandler);
			
			super.paused = v;
		}
		
		/**
		 * 实际事件
		 * @param event
		 * 
		 */
		protected function tickHandler(event:TickEvent):void
		{
			
		}
		
		public override function destory() : void
		{
			Tick.instance.removeEventListener(TickEvent.TICK,tickHandler);
			super.destory();
		}
	}
}