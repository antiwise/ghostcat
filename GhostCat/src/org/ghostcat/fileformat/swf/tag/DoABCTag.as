package org.ghostcat.fileformat.swf.tag
{
	import flash.utils.ByteArray;
	
	import org.ghostcat.util.ByteArrayReader;

	public class DoABCTag extends Tag
	{
		public static const type:int = 82;
		
		public var flags:int;
		public var name:String;
		public var abcData:ByteArray;
		public override function read() : void
		{
			super.read();
			var reader:ByteArrayReader = new ByteArrayReader(bytes);
			flags = reader.readUint(4);
			name = reader.readString();
			abcData = reader.readByteArray(length - reader.bytesReaded);
		}
	}
}