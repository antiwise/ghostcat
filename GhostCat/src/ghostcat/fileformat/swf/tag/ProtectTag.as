package ghostcat.fileformat.swf.tag
{
	import ghostcat.util.ByteArrayReader;

	/**
	 * 防止导入密码
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ProtectTag extends Tag
	{
		/** @inheritDoc*/
		public override function get type() : int
		{
			return 24;
		}
		
		/**
		 * 这是一个MD5加密字符串
		 */
		public var password:String;
		/** @inheritDoc*/
		public override function read() : void
		{
			if (length > 0)
				password = bytes.readUTFBytes(length);
		}
	}
}