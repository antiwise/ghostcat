package ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import ghostcat.display.GBase;
	import ghostcat.display.viewport.Tile;
	import ghostcat.events.ItemClickEvent;
	import ghostcat.events.PropertyChangeEvent;
	import ghostcat.events.RepeatEvent;
	import ghostcat.ui.UIConst;
	import ghostcat.util.ClassFactory;
	import ghostcat.util.SearchUtil;
	import ghostcat.util.Util;

	[Event(name="change",type="flash.events.Event")]
	[Event(name="item_click",type="ghostcat.events.ItemClickEvent")]
	
	/**
	 * 没有滚动条的List
	 * 
	 * @author tangwei
	 * 
	 */
	public class GListBase extends Tile
	{
		public static var defaultSkin:ClassFactory =  new ClassFactory();
		public static var defaultItemRender:ClassFactory = new ClassFactory(GText);
		
		public var type:String = UIConst.TILE;
		
		private var _columnCount:int = -1;
		
		
		private var oldSelectedItem:DisplayObject;
		private var _selectedData:*;
		
		public function GListBase(skin:*=null,replace:Boolean = true, type:String = UIConst.TILE,itemRender:ClassFactory = null, itemSkinField:String = "render")
		{
			if (!itemRender)
				itemRender = defaultItemRender;
				
			var render:ClassFactory;
			if (skin)
			{
				var t:DisplayObject = SearchUtil.findChildByProperty(skin,"name",itemSkinField)
				if (t)
				{
					t.parent.removeChild(t);
					render = new ClassFactory(getDefinitionByName(getQualifiedClassName(t)));
				}
			}
			
			if (!render)
				render = defaultSkin;
			
			this.type = type;
			
			if (itemRender.params)
				itemRender.params[0] = render;
			else
				itemRender.params = [render];
				
			super(itemRender);
		
			setContent(skin, replace);
			
			addEventListener(RepeatEvent.ADD_REPEAT_ITEM,addRepeatItemHandler);
			addEventListener(RepeatEvent.REMOVE_REPEAT_ITEM,removeRepeatItemHandler);
			
			addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		public function getDataAt(i:int,j:int):*
		{
			if (type == UIConst.HORIZONTAL)
				return data[i];
			else if (type == UIConst.VERTICAL)
				return data[j];
			else
				return data[j * columnCount + i];
		}
		
		public function getDataFromItem(item:DisplayObject):*
		{
			var i:int = item.x / columnWidth;
			var j:int = item.y / rowHeight;
			return getDataAt(i,j);
		}
		
		public function get selectedData():*
		{
			return _selectedData;
		}

		public function set selectedData(v:*):void
		{
			_selectedData = v;
			
			if (oldSelectedItem && oldSelectedItem is GBase)
				(oldSelectedItem as GBase).selected = false;
			
			var item:DisplayObject = selectedItem;
			
			if (item && item is GBase)
				(item as GBase).selected = true;
				
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get selectedRow():int
		{
			var selectIndex:int = data.indexOf(_selectedData);
			
			if (selectIndex != -1)
			{
				if (type == UIConst.HORIZONTAL)
					return 1;
				else if (type == UIConst.VERTICAL)
					return selectIndex;
				else
					return Math.ceil(selectIndex / columnCount);
			}
			return -1;
		}

		public function set selectedRow(v:int):void
		{
			selectedData = getDataAt(selectedColumn,v);
		}
		
		public function get selectedColumn():int
		{
			var selectIndex:int = data.indexOf(_selectedData);
			
			if (selectIndex != -1)
			{
				if (type == UIConst.HORIZONTAL)
					return selectIndex;
				else if (type == UIConst.VERTICAL)
					return 1;
				else
					return selectIndex % columnCount;
			}
			return -1;
		}

		public function set selectedColumn(v:int):void
		{
			selectedData = getDataAt(v,selectedRow);
		}
		
		public function get selectedItem():DisplayObject
		{
			return getItemAt(selectedColumn,selectedRow);
		}

		public override function setContent(skin:*, replace:Boolean=true) : void
		{
			super.setContent(skin,replace);
			
			if (this.skin)
			{
				this.width = this.skin.width;
				this.height = this.skin.height;
			}
		}
		
		protected override function get contentRect():Rectangle
		{
			var rect:Rectangle = super.contentRect.clone();
			
			if (type == UIConst.HORIZONTAL)
				rect.height = height;
			else if (type == UIConst.VERTICAL)
				rect.width = width;
			
			return rect;
		}
		
		public function get columnCount():int
		{
			if (type == UIConst.HORIZONTAL)
				return data.length;
			else if (type == UIConst.VERTICAL)
				return 1;
			else
			{
				if (_columnCount > 0)
					return _columnCount;
				else
					return int(super.width / columnWidth);
			}
		}

		public function get rowCount():int
		{
			if (type == UIConst.HORIZONTAL)
				return 1;
			else if (type == UIConst.VERTICAL)
				return data ? data.length : 0;
			else
				return data ? Math.ceil(data.length / columnCount) : 0;
		}

		public function set columnCount(v:int):void
		{
			_columnCount = v;
		}

		public override function get width() : Number
		{
			return (type != UIConst.VERTICAL) ? columnWidth * columnCount : super.width;
		}
		
		public override function get height() : Number
		{
			return (type != UIConst.HORIZONTAL) ? rowHeight * rowCount : super.height;
		}
		
		public function get columnWidth():Number
		{
			return (type == UIConst.VERTICAL) ? width : _contentRect.width;
		}
		
		public function get rowHeight():Number
		{
			return (type == UIConst.HORIZONTAL) ? height : _contentRect.height;
		}
		
		public function set columnWidth(v:Number):void
		{
			_contentRect.width = v;
		}
		
		public function set rowHeight(v:Number):void
		{
			_contentRect.height = v;
		}
		
		public override function set data(v:*):void
		{
			super.data = v;
			refresh();
			
			if (v is IEventDispatcher)
				(v as IEventDispatcher).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,dataChangeHandler,false,0,true);
		}
		
		protected function dataChangeHandler(event:PropertyChangeEvent):void
		{
			var i:int;
			var j:int;
			
			if (type == UIConst.HORIZONTAL)
				i = int(event.property);
			else if (type == UIConst.VERTICAL)
				j = int(event.property);
			else
			{
				j = int(event.property) / columnCount;
				i = int(event.property) % columnCount;
			}
			
			refreshItem(i,j);
		}
		
		protected function addRepeatItemHandler(event:RepeatEvent):void
		{
			var p:Point = event.repeatPos;
			refreshItem(p.x,p.y);
		}
		
		protected function removeRepeatItemHandler(event:RepeatEvent):void
		{
			(event.repeatObj as GBase).data = null;
		}
		
		protected function clickHandler(event:MouseEvent):void
		{
			if (event.target == this)
				return;
			
			var o:DisplayObject = event.target as DisplayObject;
			while (o.parent != this)
				o = o.parent;
			
			if (ref.isClass(o))
				dispatchEvent(Util.createObject(new ItemClickEvent(ItemClickEvent.ITEM_CLICK),{item:(o as GBase).data,relatedObject:o}));
		}
		
		public function refreshItem(i:int,j:int):GBase
		{
			var item:GBase = getItemAt(i,j);
			if (item)
			{
				var d:*;
				try
				{
					if (type == UIConst.HORIZONTAL)
						d = data[i];
					else if (type == UIConst.VERTICAL)
						d = data[j];
					else
						d = data[j * columnCount + i];
				}
				catch(e:Error)
				{
					trace("error")
				}
				
				item.data = d;
				item.selected = (d == selectedData);
			}
			return item;
		}
		
		public function refresh():void
		{
			var screen:Rectangle = getItemRect(getLocalScreen());
			if (screen)
			{
				for (var j:int = screen.top;j < screen.bottom;j++)
					for (var i:int = screen.left;i < screen.right;i++)
						refreshItem(i,j);	
			}
		}
		
		public override function destory() : void
		{
			super.destory();
			
			if (data && data is IEventDispatcher)
				(data as IEventDispatcher).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,dataChangeHandler);
			
			removeEventListener(MouseEvent.CLICK,clickHandler);
			removeEventListener(RepeatEvent.ADD_REPEAT_ITEM,addRepeatItemHandler);
			removeEventListener(RepeatEvent.REMOVE_REPEAT_ITEM,removeRepeatItemHandler);
		}
	}
}