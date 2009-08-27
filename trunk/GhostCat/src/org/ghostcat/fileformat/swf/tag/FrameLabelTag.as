package org.ghostcat.fileformat.swf.tag
{
	import org.ghostcat.fileformat.swf.SWFDecoder;
	import org.ghostcat.util.ByteArrayReader;

	/**
	 * 帧标签
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class FrameLabelTag extends Tag
	{
		public override function get type() : int
		{
			return 43;
		}
		
		public var name:String;
		
		public override function read() : void
		{
			var reader:ByteArrayReader = new ByteArrayReader(bytes);
			name = SWFDecoder.readString(bytes);
		}
	}
}