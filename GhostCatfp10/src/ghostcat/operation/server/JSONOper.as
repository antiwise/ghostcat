package ghostcat.operation.server
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import ghostcat.operation.Oper;
	import ghostcat.operation.RetryOper;
	import ghostcat.util.data.Json;
	
	/**
	 * 请求JSON 
	 * @author flashyiyi
	 * 
	 */
	public class JSONOper extends HTTPOper
	{
		/**
		 * 原始返回数据 
		 */
		public var originalData:*;
		
		public function JSONOper(url:String=null,method:String = "get",para:Object=null,rhandler:Function=null,fhandler:Function=null)
		{
			super(url,method,para,rhandler,fhandler);
		}
		
		protected override function resultHandler(event:Event):void
		{
			loader.removeEventListener(Event.COMPLETE,resultHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,faultHandler);
			
			this.originalData = loader.data;
			try
			{
				this.lastResult = Json.decode(this.originalData);
			}
			catch(e:Error){};
			result(this.lastResult);
		}
		
		protected override function faultHandler(event:IOErrorEvent):void
		{
			loader.removeEventListener(Event.COMPLETE,resultHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,faultHandler);
			
			this.originalData = null;
			this.lastResult = null;
			fault(this.lastResult);
		}
	}
}