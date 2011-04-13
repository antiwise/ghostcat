package ghostcat.operation.server
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import ghostcat.events.OperationEvent;
	import ghostcat.operation.RetryOper;
	import ghostcat.util.text.URL;
	
	/**
	 * 请求HTTP 
	 * @author flashyiyi
	 * 
	 */
	public class HTTPOper extends RetryOper 
	{
		/**
		 * 请求地址 
		 */
		public var url:String;
		
		/**
		 * 参数
		 */
		public var para:Object;
		
		/**
		 * 请求方式
		 */
		public var method:String;

		/**
		 * 加载器 
		 */
		protected var loader:URLLoader;
		
		public function get data():*
		{
			return lastResult;
		}
		
		public function HTTPOper(url:String=null,method:String = "get",para:Object=null,rhandler:Function=null,fhandler:Function=null)
		{
			super();
			
			this.url = url;
			this.para = para;
			this.method = method;
			
			if (rhandler!=null)
				this.addEventListener(OperationEvent.OPERATION_COMPLETE,rhandler);
			if (fhandler!=null)
				this.addEventListener(OperationEvent.OPERATION_ERROR,fhandler);
		}
		/** @inheritDoc*/
		public override function execute():void
		{
			super.execute();
			
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,resultHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR,faultHandler);
			
			var request:URLRequest = new URLRequest(url);
			request.method = method;
			
			var vars:URLVariables = new URLVariables();
			vars.requestSessionId = new Date().getTime();
			if (para)
			{
				for (var key:String in para)
					vars[key] = para[key];
			}
			request.data = vars;
			
			loader.load(request);
		}
		
		protected function resultHandler(event:Event):void
		{
			loader.removeEventListener(Event.COMPLETE,resultHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,faultHandler);
			
			this.lastResult = loader.data;
			result(this.lastResult);
		}
		
		protected function faultHandler(event:IOErrorEvent):void
		{
			loader.removeEventListener(Event.COMPLETE,resultHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,faultHandler);
			
			this.lastResult = null;
			fault(this.lastResult);
		}
	}
}