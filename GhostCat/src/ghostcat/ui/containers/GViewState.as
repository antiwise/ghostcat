package ghostcat.ui.containers
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import ghostcat.display.GBase;
	
	/**
	 * 切换显示容器
	 * 
	 * 标签规则：子对象成为不同的View，只显示其中一个
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GViewState extends GBase
	{
		protected var _selectedIndex:int = -1;
		
		public function GViewState(skin:* = null,replace:Boolean = true)
		{
			super(skin, replace);
			
			var container:DisplayObjectContainer = content as DisplayObjectContainer;
			for (var i:int = 0; i < container.numChildren; i++)
				container.getChildAt(i).visible = false;
			
			selectedIndex = 0;
		}

		/**
		 * 选择显示的容器 
		 * @return 
		 * 
		 */
		public function get selectedChild():DisplayObject
		{
			if (_selectedIndex == -1)
				return null;
			else if (_selectedIndex >= (content as DisplayObjectContainer).numChildren)
				return null;
			else
				return (content as DisplayObjectContainer).getChildAt(_selectedIndex);
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

		/**
		 * 选择的容器的索引
		 * @return 
		 * 
		 */
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		public function set selectedIndex(v:int):void
		{
			if (_selectedIndex == v)
				return;
			
			var container:DisplayObjectContainer = content as DisplayObjectContainer;
			
			if (_selectedIndex != -1 && _selectedIndex < container.numChildren)
				container.getChildAt(_selectedIndex).visible = false;
			
			_selectedIndex = v;
			
			if (_selectedIndex != -1 && _selectedIndex < container.numChildren)
				container.getChildAt(_selectedIndex).visible = true;
		}

	}
}