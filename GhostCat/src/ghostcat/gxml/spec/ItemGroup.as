package ghostcat.gxml.spec
{
	import flash.utils.Dictionary;
	
	import ghostcat.util.Util;

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
			if (item.hasOwnProperty(idField))
				map[item[idField]] = item;
		}
		
		public function remove(item:*):void
		{
			var index:int = this.data.indexOf(item);
			if (index!=-1)
				this.data.splice(index, 1);
			
			if (item.hasOwnProperty(idField))
				delete map[item[idField]];
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
				if (item.hasOwnProperty(idField))
					map[item[idField]] = item;
			}
		}
	}
}