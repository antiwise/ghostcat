package ghostcat.operation.server
{
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	import ghostcat.events.OperationEvent;
	import ghostcat.operation.RetryOper;

	/**
	 * 这个针对的是采用NetConnection直接实现的Remoting方式，
	 * 因为不能载入Flex的类，Flex的RemoteObject无法在这里接入，但依葫芦画瓢应该很简单。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class RemoteOper extends RetryOper
	{
		/**
		 * 连接
		 */
		public var nc:NetConnection;
		
		/**
		 * 服务端方法（全称）
		 */
		public var metord:String;
		/**
		 * 参数
		 */
		public var para:Array;
		
		public function get data():Object
		{
			return lastResult;
		}
		
		public function RemoteOper(nc:NetConnection=null,metord:String=null,para:Array=null,rhandler:Function=null,fhandler:Function=null)
		{
			super();
			
			this.nc = nc;
			this.metord = metord;
			this.para = para;
			
			if (rhandler!=null)
				this.addEventListener(OperationEvent.OPERATION_COMPLETE,rhandler);
			if (fhandler!=null)
				this.addEventListener(OperationEvent.OPERATION_ERROR,fhandler);
		}
		/** @inheritDoc*/
		public override function execute():void
		{
			super.execute();
			
			var responder:Responder = new Responder(this.result,this.fault);
			var callArgs:Array = [metord,responder];
			if (para)
				callArgs = callArgs.concat(para);
			
			nc.call.apply(nc,callArgs);
		}
	}
}