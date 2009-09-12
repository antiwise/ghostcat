package ghostcat.fileformat.swf.tag
{
	import ghostcat.fileformat.swf.SWFDecoder;
	import ghostcat.util.ByteArrayReader;

	/**
	 * 链接资源列表
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class SymbolClassTag extends Tag
	{
		public override function get type() : int
		{
			return 76;
		}
		
		public var symbolClasses:Array;
		public var links:Array;
		
		public override function read() : void
		{
			symbolClasses = [];
			links = [];
			
			var reader:ByteArrayReader = new ByteArrayReader(bytes);
			
			var len:int = bytes.readUnsignedShort();
			for (var i:int = 0;i < len;i++)
			{
				var link:int = bytes.readUnsignedShort();
				links.push(link);
				var name:String = SWFDecoder.readString(bytes);
				symbolClasses.push(name);
			}
		}
	}
}