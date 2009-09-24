package ghostcat.fileformat.swf.tag
{
	/**
	 * 代码限制
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ScriptLimitTag extends Tag
	{
		/** @inheritDoc*/
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
		/** @inheritDoc*/
		public override function read() : void
		{
			maxRecursionDepth = bytes.readUnsignedShort();
			scriptTimeoutSeconds = bytes.readUnsignedShort();
		}
	}
}