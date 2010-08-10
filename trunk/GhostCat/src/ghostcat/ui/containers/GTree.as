package ghostcat.ui.containers
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import ghostcat.events.GEvent;
	import ghostcat.events.ItemClickEvent;
	import ghostcat.events.TreeEvent;
	import ghostcat.ui.UIConst;
	import ghostcat.ui.controls.GButton;
	import ghostcat.ui.controls.GText;
	import ghostcat.util.core.ClassFactory;
	import ghostcat.util.core.Singleton;
	import ghostcat.util.data.XMLUtil;
	
 	[Event(name="tree_click",type="ghostcat.events.TreeEvent")]
 	[Event(name="tree_close",type="ghostcat.events.TreeEvent")]
 	[Event(name="tree_open",type="ghostcat.events.TreeEvent")]
 	[Event(name="tree_opening",type="ghostcat.events.TreeEvent")]
	/**
	 * 树
	 * 
	 * 标签规则：子对象labelButton被转化为展开的按钮，list被转换为列表项，第二层的labelButton,list则继续放在list之内。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GTree extends GDrawerPanel
	{
		public var labelButton:GButton;
		public var list:GRepeater;
		
		public var labelField:String = "label";
		public var childrenField:String = "children";
		
		public var fields:Object = {labelButtonField:"labelButton",listField:"list"};
		
		public function GTree(skin:*=null, replace:Boolean=true, itemRender:* = null)
		{
			super(skin, replace);
			this.itemRender = itemRender ? itemRender : this["constructor"];
		}
		
		public override function setContent(skin:*, replace:Boolean=true):void
		{
			super.setContent(skin,replace);
			
			if (this.content[fields.labelButtonField])
			{
				this.labelButton = new GButton(this.content[fields.labelButtonField]);
				this.labelButton.addEventListener(MouseEvent.CLICK,labelClickHandler);
				this.drawRect = this.labelButton.getRect(this);
			}
			
			if (this.content[fields.listField])
			{
				this.list = new GRepeater(this.content[fields.listField]);
				this.list.type = UIConst.VERTICAL;
				this.list.addEventListener(GEvent.REFRESH_COMPLETE,listRefreshHandler);
			}
		}
		
		/**
		 * 子对象渲染器 
		 * @return 
		 * 
		 */
		public function get itemRender():*
		{
			return this.list ? this.list.itemRender : null;
		}
		
		public function set itemRender(v:*):void
		{
			if (this.list)
				this.list.itemRender = v;
		}
		
		/**
		 * label为显示文字，children为下层列表
		 */
		public override function set data(v:*):void
		{
			super.data = data;
			
			if (this.labelButton)
				this.labelButton.label = data[labelField];
			
			if (this.list)
			{
				this.list.data = data[childrenField];
				if (this.labelButton && data[childrenField])
					this.labelButton.toggle = true;
			}
		}
		
		/**
		 * 设置XML数据,@label为文字 
		 * @param xml
		 * 
		 */
		public function setXMLData(xml:XML):void
		{
			this.data = transXML(xml);
		}
		
		private function transXML(xml:XML):Object
		{
			var r:Object = {};
			var child:XML;
			for each (child in xml.attributes())
				r[child.name().toString()] = child.toString();
			
			var l:Array = [];
			for each (child in xml.children())
				l.push(transXML(child));
			
			if (l.length > 0)
				r[childrenField] = l;
			
			return r;
		}
		
		/**
		 * label点击事件 
		 * @param event
		 * 
		 */
		protected function labelClickHandler(event:MouseEvent):void
		{
			dispatchEvent(TreeEvent.createTreeEvent(TreeEvent.TREE_CLICK,data,this));
		
			var bo:Boolean = list && list.data && labelButton.selected;
			if (this.opened == bo)
				return;
				
			if (bo)
			{
				var e:TreeEvent = TreeEvent.createTreeEvent(TreeEvent.TREE_OPENING,data,this);
				dispatchEvent(e);
				
				if (e.isDefaultPrevented())
					return;
			}
			
			this.opened = bo;
		
			if (bo)
				dispatchEvent(TreeEvent.createTreeEvent(TreeEvent.TREE_OPEN,data,this));
			else
				dispatchEvent(TreeEvent.createTreeEvent(TreeEvent.TREE_CLOSE,data,this));
		}
		
		/**
		 * 将列表的事件向上传递 
		 * @param event
		 * 
		 */
		protected function listItemTreeHandler(event:TreeEvent):void
		{
			dispatchEvent(event);
		}
		
		/**
		 * 列表项更新事件 
		 * @param event
		 * 
		 */
		protected function listRefreshHandler(event:GEvent):void
		{
			if (list)
			{
				for (var i:int = 0;i < list.numChildren;i++)
				{
					var child:GTree = list.getChildAt(i) as GTree;
					if (child)
					{
						child.addEventListener(TreeEvent.TREE_CLICK,listItemTreeHandler,false,0,true);
						child.addEventListener(TreeEvent.TREE_CLOSE,listItemTreeHandler,false,0,true);
						child.addEventListener(TreeEvent.TREE_OPEN,listItemTreeHandler,false,0,true);
						child.addEventListener(TreeEvent.TREE_OPENING,listItemTreeHandler,false,0,true);
					}
				}
			}
		}
		
		/**
		 * 销毁事件 
		 * 
		 */
		public override function destory():void
		{
			if (labelButton)
			{
				labelButton.destory();
				labelButton.removeEventListener(MouseEvent.CLICK,labelClickHandler);
			}
			
			if (list)
			{
				list.removeEventListener(GEvent.REFRESH_COMPLETE,listRefreshHandler);
				list.destory();
			}	
			super.destory();
		}
		
	}
}