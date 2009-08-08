package org.ghostcat.operation
{
	import flash.events.EventDispatcher;

	/**
	 * 监听事件，事件触发时继续
	 *  
	 * @param obj	监听的对象
	 * @param event	监听的事件
	 * 
	 */
	public class WatchOper extends TimeoutOper
	{
		public var obj:EventDispatcher;
		public var event:String;
		public function WatchOper(obj:EventDispatcher,event:String)
		{
			super();
			this.obj = obj;
			this.event = event;
		}
		
		public override function execute():void
		{
			super.execute();
			obj.addEventListener(this.event,result);
		}
		
		public override function result(event:*=null):void
		{
			obj.removeEventListener(this.event,result);
			super.result(event);
		}
	}
}