package ghostcat.gxml.spec
{
	import flash.utils.Dictionary;

	/**
	 * 物品组管理类（用于容纳数据组）
	 * @author flashyiyi
	 * 
	 */
	public class ItemGroup
	{
		/**
		 * 组id
		 */
		public var id:String;
		/**
		 * id属性名
		 */
		public var idField:String = "id";
		
		private var _data:Array = [];
		
		/**
		 * 数据列表
		 */
		public function get data():Array
		{
			return _data;
		}

		public function set data(value:Array):void
		{
			_data = value;
			refreshMap();
		}

		/**
		 * 数据ID字典
		 */
		public var map:Dictionary = new Dictionary();
		
		/**
		 * 添加一个子对象
		 * @param item
		 * 
		 */
		public function add(item:*):void
		{
			data.push(item);
			map[item[idField]] = item;
		}
		
		/**
		 * 根据id获得子对象
		 * @param id
		 * @return 
		 * 
		 */
		public function getItemById(id:*):*
		{
			return map[id];
		}
		
		/**
		 * 更新Map 
		 * 
		 */
		public function refreshMap():void
		{
			for each (var item:* in data)
			{
				map[item[idField]] = item;
			}
		}
	}
}