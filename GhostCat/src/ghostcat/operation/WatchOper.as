package ghostcat.operation
{
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import ghostcat.util.ReflectUtil;

	/**
	 * 监听事件，事件触发时继续
	 *  
	 * @param obj	监听的对象
	 * @param event	监听的事件
	 * 
	 */
	public class WatchOper extends TimeoutOper
	{
		/**
		 * 对象
		 */
		public var target:*;
		
		/**
		 * 监听的事件 
		 */
		public var event:String;
		
		protected function get dispatcher():EventDispatcher
		{
			if (target is EventDispatcher)
				return target as EventDispatcher
			else
				return ReflectUtil.eval(target.toString());
		}
		
		public function WatchOper(target:*=null,event:String=null)
		{
			super();
			
			this.target = target;
			this.event = event;
		}
		/** @inheritDoc*/
		public override function execute():void
		{
			super.execute();
			this.dispatcher.addEventListener(this.event,result);
		}
		/** @inheritDoc*/
		protected override function end(event:*=null):void
		{
			if (event)
				event.currentTarget.removeEventListener(this.event,result);
			
			super.end(event);
		}
	}
}