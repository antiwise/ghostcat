package ghostcat.ui.containers
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import ghostcat.display.GBase;
	
	public class ViewState extends GBase
	{
		private var _selectedIndex:int;
		
		public function ViewState(skin:DisplayObjectContainer = null,replace:Boolean = true)
		{
			super(skin, replace)
		}

		public function get selectedChild():DisplayObject
		{
			return _selectedIndex != -1 ? (content as DisplayObjectContainer).getChildAt(_selectedIndex) : null;
		}

		public function set selectedChild(v:DisplayObject):void
		{
			var container:DisplayObjectContainer = content as DisplayObjectContainer;
			
			for (var i:int = 0; i < container.numChildren; i++)
			{
				if (v == container.getChildAt(i))
				{
					selectedIndex = i;
					return;
				}
			}
			selectedIndex = -1;
		}

		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		public function set selectedIndex(v:int):void
		{
			if (_selectedIndex == v)
				return;
				
			_selectedIndex = v;
			
			var container:DisplayObjectContainer = content as DisplayObjectContainer;
			
			for (var i:int = 0; i < container.numChildren; i++)
				container.getChildAt(i).visible = (_selectedIndex == i);
		}

	}
}