package org.ghostcat.fileformat.swf.tag
{
	/**
	 * 代码限制
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ScriptLimitTag extends Tag
	{
		public override function get type() : int
		{
			return 65;
		}
		
		/**
		 * 代码最大递归次数
		 */
		public var maxRecursionDepth:int;
		
		/**
		 * 代码超时时间
		 */
		public var scriptTimeoutSeconds:int;
		
		public override function read() : void
		{
			super.read();
			
			maxRecursionDepth = bytes.readUnsignedShort();
			scriptTimeoutSeconds = bytes.readUnsignedShort();
		}
	}
}