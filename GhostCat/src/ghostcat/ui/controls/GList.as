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
	 * 通过包装GScrollPanel，提供了滚动条的List。不支持背景。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GList extends GScrollPanel
	{
		public var listContent:GListBase;
		public var fields:Object = {renderField:"render"};
		
		private var itemRender:ClassFactory;
		private var _type:String;
		
		public function GList(skin:*=null,replace:Boolean = true, type:String = UIConst.TILE,itemRender:ClassFactory = null,fields:Object = null)
		{
			if (fields)
				this.fields = fields;
			
			this.type = type;
			this.itemRender = itemRender;
			
			super(skin,replace);
		}
		
		public override function setContent(skin:*, replace:Boolean=true) : void
		{
			super.setContent(skin,replace);
			
			var renderSkin:DisplayObject;
			var renderField:String = fields[renderField];
			
			if (renderField)
				renderSkin = content[renderField] as DisplayObject;
			
			if (renderSkin && renderSkin.parent)
				renderSkin.parent.removeChild(renderSkin);
			
			listContent = new GListBase(renderSkin,replace,_type,itemRender);
			addChild(listContent);
			
			content = listContent;//用listContent取代原来的content
			
			listContent.addEventListener(Event.CHANGE,eventpaseHandler);
			listContent.addEventListener(ItemClickEvent.ITEM_CLICK,eventpaseHandler);
			
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
			
			listContent.removeEventListener(Event.CHANGE,eventpaseHandler);
			listContent.removeEventListener(ItemClickEvent.ITEM_CLICK,eventpaseHandler);
		}
		
		private function eventpaseHandler(event:Event):void
		{
			dispatchEvent(event);//转移事件
		}
		
		public function set type(v:String) : void
		{
			_type = v;
			
			if (listContent) 
				listContent.type = v;
		}
		
		public function get type():String
		{
			return listContent ? listContent.type : _type;
		}
		
		/**
		 * 是否自动更新Item的大小 
		 */
		public function get autoReszieItemContent():Boolean
		{
			return listContent.autoReszieItemContent;
		}

		public function set autoReszieItemContent(v:Boolean):void
		{
			listContent.autoReszieItemContent = v;
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