package ghostcat.ui.containers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	[Event(name="change",type="flash.events.Event")]
	/**
	 * 在一组对象中选中一个对象（通过设置visible或者enabled属性）
	 * @author flashyiyi
	 * 
	 */
	public class SelectGroup extends EventDispatcher
	{
		/**
		 * 包含的对象 
		 */
		public var children:Array;
		
		/**
		 * 选择改变的属性
		 */
		public var field:String;
		
		/**
		 * 发布事件的目标 
		 */
		public var eventTarget:EventDispatcher;
		
		private var _selectedIndex:int = -1;
		
		public function SelectGroup(children:Array,clickToggle:Boolean = false,field:String = "selected")
		{
			this.children = children;
			this.field = field;
			this.eventTarget = this;
			
			for (var i:int = 0; i < children.length; i++)
			{
				var child:DisplayObject = this.children[i] as DisplayObject;
				if (child)
				{
					child[field] = false;
					if (clickToggle)
						child.addEventListener(MouseEvent.CLICK,itemClickHandler);
				}
			}
			selectedIndex = 0;
		}
		
		private function itemClickHandler(event:MouseEvent):void
		{
			this.selectedChild = event.currentTarget;
		}
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		public function set selectedIndex(value:int):void
		{
			if (_selectedIndex == value)
				return;
			
			if (_selectedIndex != -1 && children[_selectedIndex])
				children[_selectedIndex][field] = false;
			
			_selectedIndex = value;
			
			if (_selectedIndex != -1 && children[_selectedIndex])
				children[_selectedIndex][field] = true;
			
			if (this.eventTarget)
				this.eventTarget.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get selectedChild():*
		{
			if (_selectedIndex == -1)
				return null;
			else if (_selectedIndex >= children.length)
				return null;
			else 
				return children[_selectedIndex];
		}
		
		public function set selectedChild(v:*):void
		{
			this.selectedIndex = children.indexOf(v);
		}
		
		public function destory():void
		{
			for (var i:int = 0; i < children.length; i++)
			{
				var child:DisplayObject = this.children[i] as DisplayObject;
				child.removeEventListener(MouseEvent.CLICK,itemClickHandler);
			}
		}

	}
}