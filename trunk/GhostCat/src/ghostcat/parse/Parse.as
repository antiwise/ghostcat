package ghostcat.parse
{
	import flash.events.EventDispatcher;
	
	import ghostcat.util.Util;

	/**
	 * 这个类用于将操作保存为数据
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class Parse implements IParse
	{
		private var _parent:IParse;
		private var _children:Array = [];
		
		public function parse(target:*):void
		{
			var children:Array = this.children;
			if (children)
			{
				for (var i:int = 0;i < children.length;i++)
					(children[i] as IParse).parse(target);
			}
		}
		
		/** @inheritDoc*/
		public function set parent(v:IParse):void
		{
			_parent = v;
		}
		
		public function get parent():IParse
		{
			return _parent;
		}
		
		/** @inheritDoc*/
		public function set children(v:Array):void
		{
			_children = v;
		}
		
		public function get children():Array
		{
			return _children;
		}
		
		/**
		 * 添加
		 * @param obj
		 * 
		 */
		public function addChild(obj:IParse):void
		{
			children.push(obj);
			obj.parent = this;
		}
		
		/**
		 * 删除 
		 * @param obj
		 * 
		 */
		public function removeChild(obj:IParse):void
		{
			Util.remove(children,obj);
			obj.parent = null;
		}
		
		/**
		 * 创建一个由子对象组成的集合
		 *  
		 * @param para
		 * @return 
		 * 
		 */
		public static function create(para:Array):Parse
		{
			var p:Parse = new Parse();
			for (var i:int = 0;i < para.length;i++)
				p.addChild(para[i]);
			
			return p;
		}
	}
}