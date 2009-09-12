package ghostcat.operation.server
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	
	import ghostcat.debug.Debug;
	import ghostcat.operation.Queue;
	import ghostcat.operation.RemoteOper;

	/**
	 * Remoting实现类
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class RemotingProxy extends NetConnection
	{
		/**
		 * 超时时限
		 */
		public var timeout:int = 30000;
		
		/**
		 * 最大重试次数
		 */
		public var maxRetry:int = 3;
		
		/**
		 * gateWay URL
		 */
		public var gateway:String;
		
		/**
		 * 服务类的基础包名
		 */
		public var service:String;
		
		/**
		 * 队列
		 */
		public var queue:Queue;
		
		/**
		 * 出错时执行的方法
		 */
		public var faultHander:Function;
		
		/**
		 * 
		 * @param gateway	gateWay URL
		 * @param service	服务类的基础包名
		 * 
		 */
		public function RemotingProxy(gateway:String, service:String = null)
		{
			super();
			
			this.gateway = gateway;
			this.service = service;
			
			this.queue = new Queue();
			
			this.faultHander = defaultFaultHandler;
			
			this.addEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus);
			this.addEventListener(IOErrorEvent.IO_ERROR, onConnectionError);
			this.addEventListener(SecurityErrorEvent.SECURITY_ERROR , onConnectionError);
			
			this.objectEncoding = ObjectEncoding.AMF3;
			
			this.connect(gateway);
		}
		
		public function operate(method:String,para:Array=null,rHander:Function=null,fHander:Function=null):RemoteOper
		{
			if (service)
				method = service + "." + method;
			
			var oper:RemoteOper = new RemoteOper(this, method, para, rHander, fHander);
			oper.timeout = timeout;
			oper.maxRetry = maxRetry;
			oper.commit(queue);
			
			return oper;
		}
			
		protected function onConnectionError(event:ErrorEvent):void
		{
			this.faultHander(event);
		}
		
		protected function onConnectionStatus(event:NetStatusEvent):void
		{
			switch(event.info.code) {
				case "NetConnection.Connect.Failed":
					this.faultHander(event);
					break;
			}
		}
		
		protected function defaultFaultHandler(event:Event):void
		{
			if (event is ErrorEvent)
				Debug.trace("Remote","REMOTE_ERROR:" + event);
		
			if (event is NetStatusEvent)
				Debug.trace("Remote","REMOTE_CONECT_FAILED");
		}		
	}
}