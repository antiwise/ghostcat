//ProductID (UI32)
//0: Unknown
//1: Macromedia Flex for J2EE
//2: Macromedia Flex for .NET
//3: Adobe Flex 
//Edition (UI32)
//0: Developer Edition
//1: Full Commercial Edition
//2: Non Commercial Edition
//3: Educational Edition
//4: Not For Resale (NFR) Edition
//5: Trial Edition
//6: None 
//Major Version (UI8) 
//Minor Version (UI8) 
//Build Low (UI32) 
//Build High (UI32) 
//CompilationDate (UI64)
//Milliseconds since 1.1.1970 

package ghostcat.fileformat.swf.tag
{
	import ghostcat.fileformat.swf.SWFDecoder;

	/**
	 * FLEX附加的SWF编译信息（Adobe的险恶用心）
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class ProductInfoTag extends Tag
	{
		public override function get type() : int
		{
			return 41;
		}
		
		public var productID:uint;
		public var edition:uint;
		public var majorVersion:int;
		public var minorVersion:int;
		public var buildLow:uint;
		public var buildHigh:uint;
		public var compileDate:Date;
		
		public override function read() : void
		{
			productID = bytes.readUnsignedInt();
			edition = bytes.readUnsignedInt();
			majorVersion = bytes.readUnsignedByte();
			minorVersion = bytes.readUnsignedByte();
			buildLow = bytes.readUnsignedInt();
			buildHigh = bytes.readUnsignedInt();
			compileDate = SWFDecoder.readDate(bytes);
		}
		
		public function toString() : String
		{
			const productIDs:Array = ["Unknown","Macromedia Flex for J2EE","Macromedia Flex for .NET","Adobe Flex"];
			const editions:Array = ["Developer Edition","Full Commercial Edition","Non Commercial Edition","Educational Edition","Not For Resale (NFR) Edition","Trial Edition","None"];
			return "productID:"+ productIDs[productID] + 
					", edition:"+ editions[edition] + 
					", version:"+ majorVersion + "." + minorVersion + "." + buildHigh + "." + buildLow + 
					", compileDate:" + compileDate;
		}
	}
}