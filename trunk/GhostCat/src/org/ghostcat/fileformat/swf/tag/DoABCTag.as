package org.ghostcat.fileformat.swf.tag
{
	import flash.utils.ByteArray;
	
	import org.ghostcat.fileformat.swf.SWFDecoder;
	import org.ghostcat.util.ByteArrayReader;

	/**
	 * AS3代码Tag
	 *  
	 * @author flashyiyi
	 * 
	 */
	public class DoABCTag extends Tag
	{
		public override function get type() : int
		{
			return 82;
		}
		
		public var flags:int;
		public var name:String;
		public var abcData:ByteArray;
		public override function read() : void
		{
			var reader:ByteArrayReader = new ByteArrayReader(bytes);
			flags = bytes.readUnsignedInt();
			name = SWFDecoder.readString(bytes);
			abcData = reader.readByteArray(length - reader.bytesReaded);
		}
	}
}