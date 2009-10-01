package ghostcat.fileformat.swf.tag
{
	import ghostcat.fileformat.swf.SWFDecoder;
	import ghostcat.util.data.ByteArrayReader;

	/**
	 * 帧标签
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class FrameLabelTag extends Tag
	{
		/** @inheritDoc*/
		public override function get type() : int
		{
			return 43;
		}
		
		public var name:String;
		/** @inheritDoc*/
		public override function read() : void
		{
			var reader:ByteArrayReader = new ByteArrayReader(bytes);
			name = SWFDecoder.readString(bytes);
		}
	}
}