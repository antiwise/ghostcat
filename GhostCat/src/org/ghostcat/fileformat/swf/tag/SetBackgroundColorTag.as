package org.ghostcat.fileformat.swf.tag
{
	/**
	 * 背景色
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class SetBackgroundColorTag extends Tag
	{
		public static const type:int = 9;
		
		/**
		 * 背景色
		 */
		public var backgroundColor:uint;
		
		public override function read() : void
		{
			super.read();
			
			var r:int = bytes.readUnsignedByte();
			var g:int = bytes.readUnsignedByte();
			var b:int = bytes.readUnsignedByte(); 
			backgroundColor = (r << 16) | (g << 8) | b;
		}
	}
}