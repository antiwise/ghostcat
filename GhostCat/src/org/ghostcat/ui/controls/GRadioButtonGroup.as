package org.ghostcat.ui.controls
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import org.ghostcat.util.Util;
	
	[Event(name="change",type="flash.events.Event")]
	
	/**
	 * 单选框组对象。
	 * 请用getGroupByName方法创建并获取。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GRadioButtonGroup extends EventDispatcher
	{
		private static var groups:Dictionary = new Dictionary();
		
		public static function getGroupByName(name:String):GRadioButtonGroup
		{
			if (!groups[name])
				groups[name] = new GRadioButtonGroup(name);
			
			return groups[name];
		}
		
		/**
		 * 组名
		 */
		public var groupName:String;
		
		/**
		 * 包含的单选框
		 */
		public var items:Array;
		
		private var _selectedItem:GRadioButton;
		
		/**
		 * 选择的组
		 */
		public function get selectedItem():GRadioButton
		{
			return _selectedItem;
		}

		public function set selectedItem(v:GRadioButton):void
		{
			if (_selectedItem == v)
				return;
			
			_selectedItem = v;
			
			for (var i:int = 0;i < items.length;i++)
			{
				var item:GRadioButton = items[i] as GRadioButton;
				item.selected =  (item == v);
			}
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * 选择的值
		 */
		public function get selectedValue():*
		{
			return _selectedItem ? _selectedItem.value : null;
		}
		
		public function set selectedValue(v:*):void
		{
			for (var i:int = 0;i < items.length;i++)
			{
				var item:GRadioButton = items[i] as GRadioButton;
				if (item.value == v)
				{
					selectedItem = item;
					return;
				}
			}
			selectedItem = null;
		}
		
		/**
		 * 手动执行构造方法是无效的，应当使用getGroupByName方法创建
		 * 
		 * @param groupName
		 * 
		 */
		public function GRadioButtonGroup(groupName:String)
		{
			this.groupName = groupName;
		}
		
		public function addItem(item:GRadioButton):void
		{
			if (!items)
				items = [item];
			else
				items.push(item);
		}
		
		public function removeItem(item:GRadioButton):void
		{
			if (items)
			{
				Util.remove(items,this);
				if (items.length == 0)
					delete groups[groupName];
			}
		}
	}
}