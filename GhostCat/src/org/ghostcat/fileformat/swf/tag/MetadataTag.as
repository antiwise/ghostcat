package org.ghostcat.fileformat.swf.tag
{
	import org.ghostcat.fileformat.swf.SWFDecoder;
	import org.ghostcat.util.ByteArrayReader;

	/**
	 * FLASH的内部Metadata
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class MetadataTag extends Tag
	{
		public override function get type() : int
		{
			return 77;
		}
		
		public var metadata:XML;
		
		public override function read() : void
		{
			super.read();
			
			var bytesReader:ByteArrayReader = new ByteArrayReader(bytes);
			var text:String = SWFDecoder.readString(bytes);
			metadata = new XML(text);
		}
	}
}