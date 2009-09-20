package ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import ghostcat.events.ItemClickEvent;
	import ghostcat.ui.UIConst;
	import ghostcat.ui.containers.GScrollPanel;
	import ghostcat.util.ClassFactory;
	
	[Event(name="change",type="flash.events.Event")]
	[Event(name="item_click",type="ghostcat.events.ItemClickEvent")]
	
	/**
	 * 通过包装GScrollPanel，提供了滚动条的List
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GList extends GScrollPanel
	{
		public var listContent:GListBase;
		
		public function GList(skin:*=null,replace:Boolean = true, type:String = UIConst.TILE,itemRender:ClassFactory = null, itemSkinField:String = "render")
		{
			listContent = new GListBase(skin,replace,type,itemRender,itemSkinField);
			super(listContent);
		}
		
		public override function setContent(skin:*, replace:Boolean=true) : void
		{
			if (content)
				throw new Error("不允许手动执行此方法");
			else
				super.setContent(skin,replace);
			
			if (content)
			{	
				content.addEventListener(Event.CHANGE,eventpaseHandler);
				content.addEventListener(ItemClickEvent.ITEM_CLICK,eventpaseHandler);
			}
		}
		
		protected override function updateSize() : void
		{
			super.updateSize();
			
			listContent.width = this.width;
			listContent.height = this.height;
			this.scrollRect = new Rectangle(0,0,width,height);
		}
		
		public override function destory() : void
		{
			super.destory();
			
			if (content)
			{
				content.removeEventListener(Event.CHANGE,eventpaseHandler);
				content.removeEventListener(ItemClickEvent.ITEM_CLICK,eventpaseHandler);
			}
		}
		
		private function eventpaseHandler(event:Event):void
		{
			dispatchEvent(event);//转移事件
		}
		
		
		
		
		
		public function set type(v:String) : void
		{
			listContent.type = v;
		}
		
		public function get type():String
		{
			return listContent.type;
		}
		
		public override function set data(v:*) : void
		{
			listContent.data = v;
		}
		
		public override function get data() : *
		{
			return listContent.data;
		}
		
		public function get selectedData():*
		{
			return listContent.selectedData;
		}

		public function set selectedData(v:*):void
		{
			listContent.selectedData = v;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get selectedRow():int
		{
			return listContent.selectedRow;
		}

		public function set selectedRow(v:int):void
		{
			listContent.selectedData = v;
		}
		
		public function get selectedColumn():int
		{
			return listContent.selectedColumn;
		}

		public function set selectedColumn(v:int):void
		{
			listContent.selectedColumn = v;
		}
		
		public function get selectedItem():DisplayObject
		{
			return listContent.selectedItem;
		}
		
		public function get columnCount():int
		{
			return listContent.columnCount;
		}

		public function get rowCount():int
		{
			return listContent.rowCount;
		}

		public function set columnCount(v:int):void
		{
			listContent.columnCount = v;
		}

		public function get listWidth() : Number
		{
			return listContent.width;
		}
		
		public function get listHeight() : Number
		{
			return listContent.height;
		}
		
		public function get columnWidth():Number
		{
			return listContent.columnWidth;
		}
		
		public function get rowHeight():Number
		{
			return listContent.rowHeight;
		}
		
		public function set columnWidth(v:Number):void
		{
			listContent.columnWidth = v;
		}
		
		public function set rowHeight(v:Number):void
		{
			listContent.rowHeight = v;
		}
	}
}