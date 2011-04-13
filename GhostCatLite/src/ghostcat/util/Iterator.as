package ghostcat.util
{
	/**
	 * 迭代器
	 * @author flashyiyi
	 * 
	 */
	public class Iterator
	{
		public var data:*;
		public var next:Iterator;
		public function Iterator(data:* = null, prev:Iterator = null)
		{
			if (data)
				this.data = data;
		
			if (prev)
				prev.next = this;
		}
		
		public function createNext(data:*):Iterator
		{
			this.next = new Iterator(data);
			return this.next;
		}
		
		public static function create(source:Array):Iterator
		{
			var len:int = source.length;
			if (len == 0)
				return new Iterator();
			
			var start:Iterator = new Iterator();
			start.data = source[0];
			var cur:Iterator = start;
			for (var i:int = 1;i < len;i++)
			{
				cur.next = new Iterator();
				cur = cur.next;
				cur.data = source[i];
			}
			return start;
		}
	}
}