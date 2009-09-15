package ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import ghostcat.display.IData;
	import ghostcat.display.viewport.Tile;
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
		
		public function GList(skin:*,replace:Boolean = true, itemRender:ClassFactory = null, renderField:String = "render")
		{
			if (!itemRender)
				itemRender = defaultItemRender;
			
			var render:ClassFactory;
			if (skin)
			{
				var t:DisplayObject = SearchUtil.findChildByProperty(skin,"name",renderField)
				if (t)
				{
					t.parent.removeChild(t);
					render = new ClassFactory(getDefinitionByName(getQualifiedClassName(t)));
				}
			}
			
			if (!render)
				render = defaultSkin;
			
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
			
			this.width = skin.width;
			this.height = skin.height;
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
		
		public function get columnWidth():Number
		{
			return _contentRect.width;
		}
		
		public function set columnWidth(v:Number):void
		{
			_contentRect.width = v;
		}
		
		public function get rowHeight():Number
		{
			return _contentRect.height;
		}
		
		public function set rowHeight(v:Number):void
		{
			_contentRect.height = v;
		}
		
		public override function set data(v:*):void
		{
			super.data = v;
			refresh();
		}
		
		public function refresh():void
		{
			var screen:Rectangle = getItemRect(getLocalScreen());
			
			for (var j:int = screen.top;j < screen.bottom;j++)
				for (var i:int = screen.left;i < screen.right;i++)
					refreshItem(i,j);	
			
		}
		
		protected function addRepeatItemHandler(event:RepeatEvent):void
		{
			var p:Point = event.repeatPos;
			refreshItem(p.x,p.y);
		}
		
		protected function refreshItem(i:int,j:int):void
		{
			var d:*;
			if (type == HLIST)
				d = data[i];
			else if (type == VLIST)
				d = data[j];
			else
				d = data[j][i]
			
			(getItem(i,j) as IData).data = d;
		}
		
		protected function removeRepeatItemHandler(event:RepeatEvent):void
		{
			(event.repeatObj as IData).data = null;
		}
		
		public override function destory() : void
		{
			super.destory();
			
			removeEventListener(RepeatEvent.ADD_REPEAT_ITEM,addRepeatItemHandler);
			removeEventListener(RepeatEvent.REMOVE_REPEAT_ITEM,removeRepeatItemHandler);
		}
	}
}