package ghostcat.fileformat.swf.tag
{
	/**
	 * FB调试编译时将会产生的一个DebugId
	 * 格式如：uUid:4b283ecb-437a-ac5a-89ec-ed4c394b7424
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class DebugIDTag extends Tag
	{
		/** @inheritDoc*/
		public override function get type() : int
		{
			return 63;
		}
		
		public var uUid:Array;
		
		public function get uUidString():String
		{
			if (!uUid)
				return null;
			
			return getHashString(uUid[0]) + getHashString(uUid[1]) +
					"-" + getHashString(uUid[2]) + "-" + getHashString(uUid[3]) + "-" + getHashString(uUid[4]) +
					"-" + getHashString(uUid[5]) + getHashString(uUid[6]) + getHashString(uUid[7])
		}
		
		private function getHashString(v:uint):String
		{
			var s:String = v.toString(16);
			while (s.length < 4)
				s = "0" + s;
			return s;
		}
		
		public override function read() : void
		{
			uUid =[];
			for (var i:int = 0;i < 8;i++)
				uUid.push(bytes.readUnsignedShort());
		}
		
		public function toString():String
		{
			return "uUid:" + uUidString;
		}
	}
}