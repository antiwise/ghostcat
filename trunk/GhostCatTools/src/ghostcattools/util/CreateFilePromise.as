package ghostcattools.util
{
	import flash.desktop.IFilePromise;
	import flash.events.ErrorEvent;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	
	public class CreateFilePromise implements IFilePromise
	{
		private var _relativePath:String
		private var bytes:ByteArray;
		public function CreateFilePromise(relativePath:String,bytes:ByteArray)
		{
			this._relativePath = relativePath;
			this.bytes = bytes;
		}
		
		public function get relativePath():String
		{
			return _relativePath;
		}
		
		public function get isAsync():Boolean
		{
			return false;
		}
		
		public function open():IDataInput
		{
			bytes.position = 0;
			return bytes;
		}
		
		public function close():void
		{
		}
		
		public function reportError(e:ErrorEvent):void
		{
		}
	}
}