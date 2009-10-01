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
	import ghostcat.display.GSprite;
	import ghostcat.display.viewport.Tile;
	import ghostcat.events.ItemClickEvent;
	import ghostcat.events.PropertyChangeEvent;
	import ghostcat.events.RepeatEvent;
	import ghostcat.skin.ListBackground;
	import ghostcat.ui.UIConst;
	import ghostcat.util.core.ClassFactory;
	import ghostcat.util.Util;

	[Event(name="change",type="flash.events.Event")]
	[Event(name="item_click",type="ghostcat.events.ItemClickEvent")]
	
	/**
	 * 没有滚动条的List
	 * 
	 * 标签规则：skin直接被当作重复块的skin处理
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GListBase extends Tile
	{
		public static var defaultSkin:ClassFactory =  new ClassFactory(ListBackground);
		public static var defaultItemRender:ClassFactory = new ClassFactory(GButton,null,[null,true,true]);
		
		/**
		 * 类型 
		 */
		public var type:String = UIConst.TILE;
		
		/**
		 * 是否自动更新Item的大小 
		 */
		public var autoReszieItemContent:Boolean = true;
		
		private var _columnCount:int = -1;
		
		private var oldSelectedItem:DisplayObject;
		private var _selectedData:*;
		
		/**
		 * 
		 * @param skin	Render皮肤
		 * @param replace	是否替换
		 * @param type	滚动方向
		 * @param itemRender	Render类型
		 * 
		 */
		public function GListBase(skin:*=null,replace:Boolean = true, type:String = UIConst.TILE,itemRender:ClassFactory = null)
		{
			if (!itemRender)
				itemRender = defaultItemRender;
				
			var render:ClassFactory;
			if (skin)
			{
				if (skin is DisplayObject)
				{
					var t:DisplayObject = skin;
					t.parent.removeChild(t);
					render = new ClassFactory(t["constructor"]);
				}
				else if (skin is Class)
					render = new ClassFactory(skin);
				else if (skin is ClassFactory)
					render = skin as ClassFactory
			}
			
			if (!render)
				render = defaultSkin;
			
			this.type = type;
			
			if (itemRender.params)
				itemRender.params[0] = render;
			else
				itemRender.params = [render];
				
			super(itemRender);
			
			addEventListener(RepeatEvent.ADD_REPEAT_ITEM,addRepeatItemHandler);
			addEventListener(RepeatEvent.REMOVE_REPEAT_ITEM,removeRepeatItemHandler);
			
			addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		/**
		 * 获得某个坐标的数据 
		 * @param i
		 * @param j
		 * @return 
		 * 
		 */
		public function getDataAt(i:int,j:int):*
		{
			if (type == UIConst.HORIZONTAL)
				return data[i];
			else if (type == UIConst.VERTICAL)
				return data[j];
			else
				return data[j * columnCount + i];
		}
		
		/**
		 * 由数据获得元素 
		 * @param item
		 * @return 
		 * 
		 */
		public function getDataFromItem(item:DisplayObject):*
		{
			var i:int = item.x / columnWidth;
			var j:int = item.y / rowHeight;
			return getDataAt(i,j);
		}
		
		/**
		 * 选择的数据 
		 * @return 
		 * 
		 */
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
			oldSelectedItem = item;
			
			if (item && item is GBase)
				(item as GBase).selected = true;
				
			dispatchEvent(new Event(Event.CHANGE));
			
		}
		
		/**
		 * 选择的行
		 * @return 
		 * 
		 */
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
					return selectIndex / columnCount;
			}
			return -1;
		}

		public function set selectedRow(v:int):void
		{
			selectedData = getDataAt(selectedColumn,v);
		}
		
		/**
		 * 选择的列
		 * @return 
		 * 
		 */
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
		
		/**
		 * 选择的元素 
		 * @return 
		 * 
		 */
		public function get selectedItem():DisplayObject
		{
			return getItemAt(selectedColumn,selectedRow);
		}
		
		public function set selectedItem(v:DisplayObject):void
		{
			selectedData = (v as GBase).data;
		}
		
		/**
		 * 元素大小 
		 * @return 
		 * 
		 */
		protected override function get contentRect():Rectangle
		{
			var rect:Rectangle = super.contentRect.clone();
			
			if (type == UIConst.HORIZONTAL)
				rect.height = height;
			else if (type == UIConst.VERTICAL)
				rect.width = width;
			
			return rect;
		}
		
		/**
		 * 总列数 
		 * @param v
		 * 
		 */
		public function set columnCount(v:int):void
		{
			_columnCount = v;
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
					return Math.ceil(super.width / columnWidth);
			}
		}

		/**
		 * 总行数 
		 * @return 
		 * 
		 */
		public function get rowCount():int
		{
			if (type == UIConst.HORIZONTAL)
				return 1;
			else if (type == UIConst.VERTICAL)
				return data ? data.length : 0;
			else
				return data ? Math.ceil(data.length / columnCount) : 0;
		}

		/**
		 * 组件的宽度 
		 * @return 
		 * 
		 */
		public override function get width() : Number
		{
			return (type != UIConst.VERTICAL) ? columnWidth * columnCount : super.width;
		}
		
		/**
		 * 组件的高度 
		 * @return 
		 * 
		 */
		public override function get height() : Number
		{
			return (type != UIConst.HORIZONTAL) ? rowHeight * rowCount : super.height;
		}
		
		/**
		 * 列宽 
		 * @return 
		 * 
		 */
		public function get columnWidth():Number
		{
			return (type == UIConst.VERTICAL) ? width : _contentRect.width;
		}
		
		public function set columnWidth(v:Number):void
		{
			_contentRect.width = v;
		}
		
		/**
		 * 行高
		 * @return 
		 * 
		 */
		public function get rowHeight():Number
		{
			return (type == UIConst.HORIZONTAL) ? height : _contentRect.height;
		}
		
		public function set rowHeight(v:Number):void
		{
			_contentRect.height = v;
		}
		/** @inheritDoc*/
		public override function set data(v:*):void
		{
			super.data = v;
			refresh();
			
			if (v is IEventDispatcher)
				(v as IEventDispatcher).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,dataChangeHandler,false,0,true);
		}
		
		/**
		 * 通过外部修改数据源变化事件 
		 * @param event
		 * 
		 */
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
		
		/**
		 * 增加元素事件 
		 * @param event
		 * 
		 */
		protected function addRepeatItemHandler(event:RepeatEvent):void
		{
			var p:Point = event.repeatPos;
			var item:GBase = event.repeatObj as GBase;
			refreshItem(p.x,p.y);
			
			item.visible = (item.data != null);
		}
		
		/**
		 * 移除元素事件 
		 * @param event
		 * 
		 */
		protected function removeRepeatItemHandler(event:RepeatEvent):void
		{
			var item:GBase = event.repeatObj as GBase;
			item.data = null;
			item.visible = item.selected = false;
		}
		
		/**
		 * 点击事件 
		 * @param event
		 * 
		 */
		protected function clickHandler(event:MouseEvent):void
		{
			if (event.target == this)
				return;
			
			var o:DisplayObject = event.target as DisplayObject;
			while (o.parent != this)
				o = o.parent;
			
			if (ref.isClass(o))
			{
				selectedItem = o;
				dispatchEvent(Util.createObject(new ItemClickEvent(ItemClickEvent.ITEM_CLICK),{item:(o as GBase).data,relatedObject:o}));
			}
		}
		
		/**
		 * 刷新某个坐标的元素 
		 * @param i
		 * @param j
		 * @return 
		 * 
		 */
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
				if (autoReszieItemContent)
				{
					item.content.width = columnWidth;
					item.content.height = rowHeight;
				}
				item.selected = (d == selectedData);
			}
			return item;
		}
		
		/**
		 * 刷新元素的内容 
		 * 
		 */
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
		/** @inheritDoc*/
		public override function destory() : void
		{
			super.destory();
			
			if (data && data is IEventDispatcher)
				(data as IEventDispatcher).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,dataChangeHandler);
				
			for (var i:int = 0; i < numChildren;i++)
			{
				if (getChildAt(i) is GSprite)
					(getChildAt(i) as GSprite).destory();
			}
			
			removeEventListener(MouseEvent.CLICK,clickHandler);
			removeEventListener(RepeatEvent.ADD_REPEAT_ITEM,addRepeatItemHandler);
			removeEventListener(RepeatEvent.REMOVE_REPEAT_ITEM,removeRepeatItemHandler);
		}
	}
}