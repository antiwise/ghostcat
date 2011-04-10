package ghostcat.operation.server
{
	import flash.utils.ByteArray;
	
	import ghostcat.operation.Oper;
	
	public class SocketReceiveOper extends Oper
	{
		public var bytes:ByteArray;
		public function SocketReceiveOper(bytes:ByteArray)
		{
			super();
			this.bytes = bytes;
		}
	}
}