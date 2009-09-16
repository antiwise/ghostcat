package ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import ghostcat.display.IData;
	import ghostcat.display.viewport.Tile;
	import ghostcat.events.PropertyChangeEvent;
	import ghostcat.events.RepeatEvent;
	import ghostcat.util.ClassFactory;
	import ghostcat.util.SearchUtil;
	
	public class GList extends Tile
	{
		public static const TILE:String = "tile";
		public static const HLIST:String = "hlist";
		public static const VLIST:String = "vlist";
		
		public static var defaultSkin:ClassFactory =  new ClassFactory();
		public static var defaultItemRender:ClassFactory = new ClassFactory(GText);
		
		public var type:String = TILE;
		
		private var _columnCount:int = -1;
		
		public function GList(skin:*=null,replace:Boolean = true, type:String = TILE,itemRender:ClassFactory = null, itemSkinField:String = "render")
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
			
			if (type == HLIST)
				rect.height = height;
			else if (type == VLIST)
				rect.width = width;
			
			return rect;
		}
		
		public function get columnCount():int
		{
			if (type == HLIST)
				return data.length;
			else if (type == VLIST)
				return 1;
			else
			{
				if (_columnCount > 0)
					return _columnCount;
				else
					return Math.ceil(super.width / columnWidth);
			}
		}

		public function get rowCount():int
		{
			if (type == HLIST)
				return 1;
			else if (type == VLIST)
				return data ? data.length : 0;
			else
				return data ? data.length / columnCount : 0;
		}

		public function set columnCount(v:int):void
		{
			_columnCount = v;
		}

		public override function get width() : Number
		{
			return (type != VLIST) ? columnWidth * columnCount : super.width;
		}
		
		public override function get height() : Number
		{
			return (type != HLIST) ? rowHeight * rowCount : super.height;
		}
		
		public function get columnWidth():Number
		{
			return (type == VLIST) ? width : _contentRect.width;
		}
		
		public function get rowHeight():Number
		{
			return (type == HLIST) ? height : _contentRect.height;
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
			
			if (type == HLIST)
				i = int(event.property);
			else if (type == VLIST)
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
			(event.repeatObj as IData).data = null;
		}
		
		public function refreshItem(i:int,j:int):Boolean
		{
			var d:*;
			try
			{
				if (type == HLIST)
					d = data[i];
				else if (type == VLIST)
					d = data[j];
				else
					d = data[j * columnCount + i];
			}
			catch(e:Error)
			{
				return false;
			}
			var item:IData = getItem(i,j);
			if (item)
				item.data = d;
			return true;
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
		
			
			removeEventListener(RepeatEvent.ADD_REPEAT_ITEM,addRepeatItemHandler);
			removeEventListener(RepeatEvent.REMOVE_REPEAT_ITEM,removeRepeatItemHandler);
		}
	}
}