package org.ghostcat.fileformat.swf.tag
{
	import org.ghostcat.util.ByteArrayReader;

	/**
	 * 防止导入密码
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ProtectTag extends Tag
	{
		public override function get type() : int
		{
			return 24;
		}
		
		/**
		 * 这是一个MD5加密字符串
		 */
		public var password:String;
		
		public override function read() : void
		{
			super.read();
			
			if (length > 0)
				password = bytes.readUTFBytes(length);
		}
	}
}