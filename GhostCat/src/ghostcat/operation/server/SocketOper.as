package ghostcat.operation.server
{
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import ghostcat.events.OperationEvent;
	import ghostcat.operation.Oper;
	
	/**
	 * Socket请求
	 * @author flashyiyi
	 * 
	 */
	public class SocketOper extends Oper
	{
		/**
		 * 服务
		 */
		public var service:SocketProxy;
		
		/**
		 * 协议ID，为-1则自动根据类查询
		 */
		public var operId:int;
		
		/**
		 * 返回数据的协议ID，为-1则不返回数据
		 */
		public var resultOperId:int;
		
		/**
		 * 上行数据
		 */
		public var params:ByteArray;
		
		/**
		 * 下行数据 
		 * @return 
		 * 
		 */
		public function get data():Object
		{
			return lastResult;
		}
		
		/**
		 * 
		 * @param service	服务
		 * @param operId	协议ID，为-1则自动根据类查询
		 * @param params	上行数据
		 * @param resultOperId	返回数据的协议ID，为-1则不返回数据
		 * @param rhandler
		 * @param fhandler
		 * 
		 */
		public function SocketOper(service:SocketProxy,operId:int = -1, params:ByteArray = null,resultOperId:int = -1,rhandler:Function = null, fhandler:Function = null)
		{
			super();
			
			this.service = service;
			this.operId = operId;
			this.resultOperId = resultOperId;
			this.params = params;
			
			if (rhandler!=null)
				this.addEventListener(OperationEvent.OPERATION_COMPLETE,rhandler);
			if (fhandler!=null)
				this.addEventListener(OperationEvent.OPERATION_ERROR,fhandler);
		}
		
		public override function execute():void
		{
			if (operId == -1)
				operId = service.getOperId(this);
			
			if (operId == -1)
				return;
			
			if (!params)
				params = new ByteArray();
			
			service.operate(operId,params);
			
			super.execute();
			
			if (resultOperId == -1)
			{
				result();
			}
			else
			{
				service.addEventListener(SocketDataEvent.SOCKET_OPER_DATA,dataHandler);
			}
		}
		
		protected function dataHandler(event:SocketDataEvent):void
		{
			service.removeEventListener(SocketDataEvent.SOCKET_OPER_DATA,dataHandler);
			if (event.id == operId)
			{
				this.lastResult = event.data;
				result(this.lastResult);
			}
		}
	}
}