package ghostcat.filter
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	import flash.geom.Point;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import ghostcat.util.Util;
	
	/**
	 * 对滤镜的代理类，可以直接设置此对象的属性改变滤镜的值，并立即更新。
	 * 必须用applyFilter方法来给对象应用滤镜，用以前的方法添加将无法被管理。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public dynamic class FilterProxy extends Proxy
	{
		protected var filter:BitmapFilter;
	
		/**
		 * 滤镜的所有者
		 */
		public var owner:DisplayObject;
		
		private var _index:int = -1;
		
		public function get index():int
		{
			return _index;
		}
		
		/**
		 * 更正编号的值。
		 */
		public function updateIndex():int
		{
			if (_index != -1 && owner)
			{
				if (Util.equal(owner.filters[_index],filter))//验证是否改变了位置
					return _index;
				else
				{
					for (var i:int = 0;i <owner.filters.length;i++)
					{
						if (i != _index && Util.equal(owner.filters[i],filter))
						{
							_index = i;
							return _index;
						}
					}
				}
			}
			_index = -1;
			return _index;
		}
		
		public function FilterProxy(filter:BitmapFilter = null)
		{
			super();
			
			this.filter = filter;
		}
		
		/**
		 * 增加滤镜
		 * 
		 * @param target
		 * 
		 */
		public function applyFilter(target:*):void
		{
			if (!filter)
				return;
			
			if (target is BitmapData)
			{
				var data:BitmapData = target as BitmapData;
				data.applyFilter(data,data.rect,new Point(),this.filter)
			}
			else if (target is DisplayObject)
			{
				this.owner = target as DisplayObject;
				
				var filters:Array = this.owner.filters;
				if (filters.length > 0)
				{
					filters.push(filter);
					this.owner.filters = filters;
					this._index = filters.length - 1;
				}
				else
				{
					this.owner.filters = [filter];
					this._index = 0;
				}
				
			}
		}
		
		/**
		 * 更改滤镜的类型
		 * 
		 * @param v
		 * 
		 */
		public function changeFilter(v:BitmapFilter):void
		{
			updateIndex();//修正编号
			
			this.filter = v;
			updateFilter();
		}
		
		/**
		 * 删除滤镜
		 * 
		 */
		public function removeFilter():void
		{
			updateIndex();
			if (index != -1)
			{
				var arr:Array = owner.filters;
				arr.splice(index,1);
				owner.filters = arr;
			}
		}
		
		/**
		 * 更新滤镜
		 * 
		 */
		public function updateFilter():void
		{
			if (owner && index!= -1)
			{
				var arr:Array = owner.filters;
				if (!arr[index])
					updateIndex();
				
				if (arr[index])
					arr[index] = filter;
					
				owner.filters = arr;
			}
		}
		
		override flash_proxy function getProperty(name:*):*
		{
			return filter?filter[name]:null;
		}
		override flash_proxy function setProperty(name:*, value:*):void
		{
			updateIndex();
			if (filter) 
				filter[name] = value;
			updateFilter();
		}
	}
}