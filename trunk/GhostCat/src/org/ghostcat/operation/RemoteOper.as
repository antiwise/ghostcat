package org.ghostcat.operation
{
	import flash.net.NetConnection;
	import flash.net.Responder;

	/**
	 * 这个针对的是采用NetConnection直接实现的Remoting方式，
	 * 因为不能载入Flex的类，Flex的RemoteObject无法在这里接入，但依葫芦画瓢应该很简单。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class RemoteOper extends RetryOper
	{
		public var nc:NetConnection;
		public var command:String;
		public var para:Array;
		
		public function RemoteOper(nc:NetConnection,command:String,...para)
		{
			this.nc = nc;
			this.command = command;
			this.para = para;
		}
		
		public override function execute():void
		{
			super.execute();
			
			var responder:Responder = new Responder(this.result,this.fault);
			nc.call.apply(nc,[command,responder].concat(para));
		}
	}
}