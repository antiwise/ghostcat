package ghostcat.parse
{
	/**
	 * 这个类用于将操作保存为数据
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class Parse implements IParse
	{
		public function parse(target:*):void
		{
			var children:Array = this.children;
			if (children)
			{
				for (var i:int = 0;i < children.length;i++)
					(children[i] as IParse).parse(target);
			}
		}
		
		private var _children:Array;
		
		/**
		 * 子对象
		 * @param v
		 * 
		 */
		public function set children(v:Array):void
		{
			_children = v;
		}
		
		public function get children():Array
		{
			return _children;
		}
		
		/**
		 * 创建
		 *  
		 * @param para
		 * @return 
		 * 
		 */
		public static function create(para:Array):Parse
		{
			var p:Parse = new Parse();
			p.children = para;
			return p;
		}
	}
}