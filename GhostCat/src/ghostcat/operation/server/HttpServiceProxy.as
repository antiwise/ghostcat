package ghostcat.operation.server
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import ghostcat.debug.Debug;
	import ghostcat.operation.LoadOper;
	import ghostcat.operation.Queue;
	import ghostcat.operation.RemoteOper;

	/**
	 * Remoting实现类
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class HttpServiceProxy extends EventDispatcher
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
		public var baseUrl:String;
				
		/**
		 * 使用的队列
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
		public function HttpServiceProxy(baseUrl:String)
		{
			super();
			
			this.baseUrl = baseUrl;
			
			this.queue = new Queue();
			
			this.faultHander = defaultFaultHandler;
			
			this.addEventListener(IOErrorEvent.IO_ERROR, onConnectionError);
			this.addEventListener(SecurityErrorEvent.SECURITY_ERROR , onConnectionError);
			
			this.connect(gateway);
		}
		
		/**
		 * 执行方法
		 * @param method	方法
		 * @param para	参数
		 * @param rHander	完成函数
		 * @param fHander	失败函数
		 * @return 
		 * 
		 */
		public function operate(method:String,para:Object=null,rHander:Function=null,fHander:Function=null):RemoteOper
		{
			if (service)
				method = service + "/" + method;
			
			var request:URLRequest = new URLRequest(method);
			request.data = new URLVariables(para);
			
			var oper:LoadOper = new LoadOper(request, null,rHander, fHander);
			oper.timeout = timeout;
			oper.maxRetry = maxRetry;
			oper.commit(queue);
			
			return oper;
		}
			
		protected function onConnectionError(event:ErrorEvent):void
		{
			this.faultHander(event);
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