package ghostcat.fileformat.swf.tag
{
	/**
	 * 背景色
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class SetBackgroundColorTag extends Tag
	{
		/** @inheritDoc*/
		public override function get type() : int
		{
			return 9;
		}
		
		/**
		 * 背景色
		 */
		public var backgroundColor:uint;
		/** @inheritDoc*/
		public override function read() : void
		{
			var r:int = bytes.readUnsignedByte();
			var g:int = bytes.readUnsignedByte();
			var b:int = bytes.readUnsignedByte(); 
			backgroundColor = (r << 16) | (g << 8) | b;
		}
	}
}