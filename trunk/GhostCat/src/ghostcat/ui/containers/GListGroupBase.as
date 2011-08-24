package ghostcat.ui.containers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	import ghostcat.display.GBase;
	import ghostcat.events.ItemClickEvent;
	import ghostcat.events.RepeatEvent;
	import ghostcat.ui.UIConst;
	import ghostcat.util.core.ClassFactory;

	/**
	 * 提供多项分页列表
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GListGroupBase extends GListBase
	{
		private var _selectedPageData:*;

		public function get selectedPageData():*
		{
			return _selectedPageData;
		}

		public function set selectedPageData(value:*):void
		{
			_selectedPageData = value;
			if (selectedItem is GRepeater && selectedData is Array && (selectedData as Array).indexOf(_selectedPageData) != -1)
				(selectedItem as GRepeater).selectedData = _selectedPageData;
		}
		
		public function GListGroupBase(skin:*=null, replace:Boolean=true, type:String=UIConst.HORIZONTAL, itemRender:*=null)
		{
			super(skin, replace, type, itemRender);
			
			this.toggleOnClick = false;
			this.addEventListener(ItemClickEvent.ITEM_CLICK,itemClickHandler);
		}
		
		public override function refreshIndex(i:int,j:int):GBase
		{
			var item:GBase = getItemAt(i,j);
			
			if (toggle && item is GRepeater)
				(item as GRepeater).selectedData = selectedPageData;
			
			return super.refreshIndex(i,j);
		}
		
		private function itemClickHandler(event:Event):void
		{
			if (toggle && toggleOnClick)
			{
				if (selectedItem is GRepeater)
					_selectedPageData = GRepeater(selectedItem).selectedData;
			}
		}
		
		protected override function addRepeatItemHandler(event:RepeatEvent):void
		{
			super.addRepeatItemHandler(event);
			var item:GBase = event.repeatObj as GBase;
			if (item is GRepeater)
			{
				item.addEventListener(ItemClickEvent.ITEM_CLICK,repeaterItemClickHandler);
			}
		}
		
		protected override function removeRepeatItemHandler(event:RepeatEvent):void
		{
			super.removeRepeatItemHandler(event);
			var item:GBase = event.repeatObj as GBase;
			if (item is GRepeater)
			{
				item.removeEventListener(ItemClickEvent.ITEM_CLICK,repeaterItemClickHandler);
			}
		}
		
		protected function repeaterItemClickHandler(event:Event):void
		{
			dispatchEvent(event);
		}
		
		/**
		 * 建立一个分页Render，原本的itemRender属性失效
		 * 
		 * @param itemRender	渲染器
		 * @param type	布局类型
		 * @param w		宽度
		 * @param h		高度
		 * @return 
		 * 
		 */
		public function createPage(itemRender:*, type:String = "tile" ,w:Number = NaN,h:Number = NaN, initObj:Object = null):void
		{
			var o:Object = {
				type : type,
				hideNullItem : this.hideNullItem,
				toggleOnClick : this.toggleOnClick,
				itemRender : itemRender,
				width : w,
				height : h
			};
			
			if (initObj)
			{
				for (var p:String in initObj)
					o[p] = initObj[p];
			}
			
			this.autoReszieItemContent = false;
			this.itemRender = new ClassFactory(GRepeater,o);
		}
		
		/**
		 * 执行createPage后，需要用它来设置分页设置数据
		 * @param source
		 * @param pageLen	每页数据个数
		 * 
		 */
		public function setPageData(source:Array,pageLen:int = 1):void
		{
			var len:int = Math.ceil(source.length / pageLen);
			var result:Array = [];
			for (var i:int = 0;i < len;i++)
			{
				result[i] = source.slice(i * pageLen,(i + 1) * pageLen);
			}
			this.data = result;
		}
		
		/**
		 * 执行createPage后，需要用它来来由数据获得元素
		 * @param v
		 * 
		 */
		public function getRenderInPage(v:*):DisplayObject
		{
			if (data)
			{
				for each (var child:Array in data)
				{
					if (child.indexOf(v) != -1)
					{
						var rep:GRepeater = getRender(child) as GRepeater;
						return rep ? rep.getRender(v) : null;
					}
				}
			}
			return null;
		}
	}
}