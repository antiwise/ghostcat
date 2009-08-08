package org.ghostcat.fileformat.swf.tag
{
	import org.ghostcat.util.ByteArrayReader;

	/**
	 * FLASH的内部Metadata
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class MetadataTag extends Tag
	{
		public static const type:int = 77;
		
		public var metadata:XML;
		
		public override function read() : void
		{
			super.read();
			
			var bytesReader:ByteArrayReader = new ByteArrayReader(bytes);
			var text:String = bytesReader.readString();
			metadata = new XML(text);
		}
	}
}