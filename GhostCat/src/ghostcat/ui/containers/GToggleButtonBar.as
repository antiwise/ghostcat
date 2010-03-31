package ghostcat.ui.containers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import ghostcat.display.GBase;
	import ghostcat.events.ItemClickEvent;
	import ghostcat.util.display.SelectGroup;

	[Event(name="change",type="flash.events.Event")]
	/**
	 * 可按下的按钮条
	 * 
	 * 标签规则：子对象的render将会被作为子对象的默认skin
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GToggleButtonBar extends GButtonBar
	{
		/**
		 * 是否点击选中
		 */
		public var toggleOnClick:Boolean = true;
		
		private var _selectedData:*;
		
		public function GToggleButtonBar(skin:*= null, replace:Boolean=true, ref:*=null)
		{
			super(skin, replace, ref);
			addEventListener(ItemClickEvent.ITEM_CLICK,itemClickHandler);
		}
		
		/**
		 * 按钮点击事件
		 * @param event
		 * 
		 */
		protected function itemClickHandler(event:ItemClickEvent):void
		{
			if (toggleOnClick && event.data)
				selectedData = event.data;
		}

		/**
		 * 选择的索引 
		 * @return 
		 * 
		 */
		public function get selectedIndex():int
		{
			return data.indexOf(selectedData);
		}

		public function set selectedIndex(v:int):void
		{
			if (v == -1)
				selectedData = null;
			else
				selectedData = data[v];
		}

		/**
		 * 选择的数据 
		 * @return 
		 * 
		 */
		public function get selectedData():*
		{
			return _selectedData;
		}

		public function set selectedData(v:*):void
		{
			if (_selectedData == v)
				return;
			
			_selectedData = v;
			for (var i:int = 0;i < contentPane.numChildren;i++)
			{
				var item:GBase = contentPane.getChildAt(i) as GBase;
				if (item)
					item.selected = v && item.data == v; 
			}
			dispatchEvent(new Event(Event.CHANGE));
		}

		/**
		 * 选择的按钮
		 * @return 
		 * 
		 */
		public function get selectedChild():DisplayObject
		{
			return contentPane.getChildAt(selectedIndex);
		}

		public function set selectedChild(v:DisplayObject):void
		{
			selectedIndex = contentPane.getChildIndex(v);
		}

	}
}