package ghostcat.operation.server
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	import ghostcat.debug.Debug;
	import ghostcat.operation.Oper;
	import ghostcat.operation.Queue;
	import ghostcat.util.data.E4XUtil;
	
	[Event(name="socket_oper_data", type="ghostcat.operation.server.SocketDataEvent")]
	/**
	 * Socket服务类。
	 * 
	 * 收到的消息会先读取一个32位的长度值，根据长度值读取一节数据。数据中第一部分是16位的ID，剩下的为实际数据。
	 * 之后会根据opers对象的值，执行相应的命令，将数据发布出去。
	 * @author flashyiyi
	 * 
	 */
	public class SocketProxy extends EventDispatcher
	{
		public var socket:Socket;
		
		/**
		 * 指令与id对照表
		 * 格式为：{id:类/函数/字符串}
		 * 函数会被执行，参数为ByteArray数据。
		 * 字符串会被反射为类。
		 * 类会被实例化，构造函数参数为ByteArray数据。
		 */
		public var opers:Object;
		
		/**
		 * 出错时执行的方法
		 */
		public var faultHander:Function;
		
		protected var cache:ByteArray;
		
		public function SocketProxy(host:String,port:int)
		{
			this.socket = new Socket(host,port);
			this.socket.addEventListener(ProgressEvent.SOCKET_DATA,socketDataHandler);
			this.socket.addEventListener(IOErrorEvent.IO_ERROR,onConnectionError);
			this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onConnectionError);
		
			this.cache = new ByteArray();
		}
		
		public function operate(id:uint,bytes:ByteArray):void
		{
			this.socket.writeUnsignedInt(2 + bytes.length);
			this.socket.writeShort(id);
			bytes.position = 0;
			this.socket.writeBytes(bytes,0,bytes.length);
			this.socket.flush();
		}
		
		protected function socketDataHandler(event:ProgressEvent):void
		{
			socket.readBytes(cache,cache.length);
			cache.position = 0;
			
			var p:int = cache.position;
			while (true)
			{
				//读取长度值
				if (cache.bytesAvailable < 4)
					break;
				var len:uint = this.cache.readUnsignedInt();
				if (len < 2)
					throw new Error("数据长度至少要大于2bytes");
				
				if (cache.bytesAvailable < len)
					break;
				
				//读取id
				var id:uint = cache.readShort();
				//读取数据
				var body:ByteArray = new ByteArray();
				cache.readBytes(body,0,len - 2);
				body.position = 0;
				
				var e:SocketDataEvent = new SocketDataEvent(SocketDataEvent.SOCKET_OPER_DATA);
				e.id = id;
				e.data = body;
				this.dispatchEvent(e);
				
				this.createOper(id,body);
				
				p = cache.position;
			}
			
			//退回到上次读取的位置将剩余的数据留下
			this.cache.position = p;
			var leftBytes:ByteArray = new ByteArray();
			cache.readBytes(leftBytes);
			
			cache = leftBytes;
		}
		
		/**
		 * 创建指令
		 * @param id
		 * @param body
		 * 
		 */
		protected function createOper(id:uint,body:ByteArray):void
		{
			if (!this.opers)
				return;
			
			var oper:* = this.opers[id];
			if (oper is String)
				oper = getDefinitionByName(oper);
			
			if (oper is Class)
			{
				new oper(body);
			}
			else if (oper is Function)
			{
				oper(body);
			}
		}
		
		protected function onConnectionError(event:Event):void
		{
			this.faultHander(event);
		}
		
		protected function defaultFaultHandler(event:Event):void
		{
			Debug.trace("HTTP","ERROR:" + event);
		}		
	}
}