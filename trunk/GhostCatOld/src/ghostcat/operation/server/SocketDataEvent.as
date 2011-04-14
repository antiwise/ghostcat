package ghostcat.operation.server
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public class SocketDataEvent extends Event
	{
		public static const SOCKET_OPER_DATA:String = "socket_oper_data";
		
		public var id:uint;
		public var data:ByteArray;
		public function SocketDataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			var e:SocketDataEvent = super.clone() as SocketDataEvent;
			e.id = this.id;
			e.data = data;
			return e;
		}
	}
}