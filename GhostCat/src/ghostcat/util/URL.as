package ghostcat.util
{
	/**
	 * URL解析
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class URL
	{
		private var _source:String;
		
		public function get source():String
		{
			return _source;
		}

		public function set source(v:String):void
		{
			_source = v;
		}

		public function URL(source:String)
		{
			this.source = source;
		}
	}
}