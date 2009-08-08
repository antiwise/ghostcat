package org.ghostcat.fileformat.swf.tag
{
	import org.ghostcat.util.ByteArrayReader;

	/**
	 * 链接资源列表
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class SymbolClassTag extends Tag
	{
		public static const type:int = 76;
		
		public var symbolClasses:Array;
		public var links:Array;
		
		public override function read() : void
		{
			super.read();
			
			symbolClasses = [];
			links = [];
			
			var reader:ByteArrayReader = new ByteArrayReader(bytes);
			
			var len:int = reader.readUint(2);
			for (var i:int = 0;i < len;i++)
			{
				var link:int = reader.readUint(2);
				links.push(link);
				var name:String = reader.readString();
				symbolClasses.push(name);
			}
		}
	}
}