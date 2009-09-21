package ghostcat.ui.containers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import ghostcat.display.GBase;
	import ghostcat.events.ItemClickEvent;

	public class GToggleButtonBar extends GButtonBar
	{
		public var toggleOnClick:Boolean = true;
		
		private var _selectedData:*;
		
		public function GToggleButtonBar(skin:*= null, replace:Boolean=true, ref:*=null)
		{
			super(skin, replace, ref);
			addEventListener(ItemClickEvent.ITEM_CLICK,itemClickHandler);
		}
		
		protected function itemClickHandler(event:ItemClickEvent):void
		{
			if (toggleOnClick)
				selectedData = event.item;
		}

		public function get selectedIndex():int
		{
			return data.indexOf(_selectedData);
		}

		public function set selectedIndex(v:int):void
		{
			if (v == -1)
				_selectedData = null;
			else
				_selectedData = data[v];
		}

		public function get selectedData():*
		{
			return _selectedData;
		}

		public function set selectedData(v:*):void
		{
			_selectedData = v;
			for (var i:int = 0;i < contentPane.numChildren;i++)
			{
				var item:GBase = contentPane.getChildAt(i) as GBase;
				if (item)
					item.selected = (item.data == data); 
			}
			
			dispatchEvent(new Event(Event.CHANGE));
		}

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