package ghostcat.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 * 管理动态显示对象自动创建取消事件
	 * @author flashyiyi
	 * 
	 */
	public class InstanceEvent extends Event
	{
		public static const INSTANCE_CREATE:String = "instance_create";
		public static const INSTANCE_DESTORY:String = "instance_destory";
		
		public var instance:DisplayObject;
		public var instanceName:String;
		public function InstanceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone() :Event
		{
			var evt:InstanceEvent = new InstanceEvent(type,bubbles,cancelable);
			evt.instance = this.instance;
			evt.instanceName = this.instanceName;
			return evt;
		}
	}
}