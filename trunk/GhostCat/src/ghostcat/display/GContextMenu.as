package ghostcat.display
{
	import flash.display.InteractiveObject;
	import flash.events.ContextMenuEvent;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	/**
	 * FLASH内置右键菜单管理类 
	 * @author flashyiyi
	 * 
	 */
	public class GContextMenu extends EventDispatcher
	{
		public var contextMenu:ContextMenu;
		
		private var separatorNext:Boolean = false;
		
		public function GContextMenu(hideBuiltInItems:Boolean = true):void
		{
			contextMenu = new ContextMenu();
			
			if	(hideBuiltInItems)
				contextMenu.hideBuiltInItems();
		}
		
		/**
		 * 根据名字获得菜单 
		 * @param label
		 * @return 
		 * 
		 */
		public function getMenuByName(label:String):ContextMenuItem
		{
			for each (var menu:ContextMenuItem in contextMenu.customItems)
			{
				if (menu.caption == label)
					return menu;
			}
			return null;
		}
		
		/**
		 * 增加一个链接 
		 * @param label
		 * @param url
		 * 
		 */
		public function addURLMenu(label:String,url:String):void
		{
			addMenu(label,urlHandler);
			
			function urlHandler():void
			{
				navigateToURL(new URLRequest(url),"_blank");
			}
		}
		
		/**
		 * 增加一个菜单 
		 * @param label
		 * @param handler
		 * 
		 */
		public function addMenu(label:String,handler:Function=null):void
		{
			var item:ContextMenuItem = new ContextMenuItem(label);
			
			if (this.separatorNext)
			{
				this.separatorNext = false;
				item.separatorBefore = true;
			}
			
			if (handler!=null)
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
			
			contextMenu.customItems.push(item);
			
			function menuItemSelectHandler(event:ContextMenuEvent):void
			{
				handler();
			}
		}
		
		/**
		 * 增加一个分隔线 
		 * 
		 */
		public function addSeparator():void
		{
			this.separatorNext = true;
		}
		
		/**
		 * 应用 
		 * @param target
		 * 
		 */
		public function parse(target:InteractiveObject):void
		{
			target.contextMenu = this.contextMenu;
		}
	}
}