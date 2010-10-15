package ghostcat.ui.containers
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ghostcat.display.GBase;
	import ghostcat.display.IGBase;
	import ghostcat.events.GEvent;
	import ghostcat.events.ItemClickEvent;
	import ghostcat.ui.controls.GButtonBase;
	import ghostcat.ui.layout.LinearLayout;
	import ghostcat.util.core.ClassFactory;
	 
	[Event(name="item_click",type="ghostcat.events.ItemClickEvent")]
	[Event(name="refresh_complete",type="ghostcat.events.GEvent")]
	
	/**
	 * 根据data复制对象排列的容器
	 * 
	 * 标签规则：这个对象并没有背景，skin将作为ItemRender的skin存在
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GRepeater extends GBox
	{
		public var ref:ClassFactory;
		
		public var hideNullItem:Boolean;
		public var renderSkin:ClassFactory;
		
		/**
		 * 是否点击选中（同时附带toggle=true的效果）
		 */
		public var toggleOnClick:Boolean;
		
		/**
		 * 是否可单选
		 */
		public var toggle:Boolean;
		
		private var _selectedData:*;
		private var _labelField:String;
		
		public function GRepeater(skin:*=null, replace:Boolean=true, ref:*=null,type:String = "horizontal")
		{
			super(skin, replace);
			
			setContent(new Sprite());//重新设置Content，避免冲突
			setLayout(layout);
			
			if (skin is DisplayObject)
				skin = skin["constructor"];
				
			if (skin is Class)
				this.renderSkin = new ClassFactory(skin)
			else if (skin is ClassFactory)
				this.renderSkin = skin as ClassFactory;
				
			if (ref is Class)
				this.ref = new ClassFactory(ref)
			else if (ref is ClassFactory)
				this.ref = ref as ClassFactory;
			
			this.contentPane.addEventListener(MouseEvent.CLICK,clickHandler);
			this.data = [];
			
			addEventListener(ItemClickEvent.ITEM_CLICK,itemClickHandler);
			
		}
		
		/**
		 * 子对象渲染器 
		 * @return 
		 * 
		 */
		public function get itemRender():*
		{
			return ref;
		}
		
		public function set itemRender(v:*):void
		{
			if (v is Class)
				v = new ClassFactory(v);
			
			this.ref = v;
//			render();
		}
		
		/**
		 * 刷新全部 
		 * 
		 */
		public function render():void
		{
			if (ref && renderSkin)
			{
				if (ref.params)
					ref.params[0] = renderSkin;
				else
					ref.params = [renderSkin];
			}
			
			var i:int;
			for (i = contentPane.numChildren - 1;i >= 0;i--)
			{
				var display:DisplayObject = contentPane.getChildAt(i);
				if (display is IGBase)
					(display as IGBase).destory();
				else
					contentPane.removeChild(display);
			}
			if (data && ref)
			{
				for (i = 0;i < data.length;i++)
				{
					if (data[i] != null || !hideNullItem)
					{	
						var obj:GBase = ref.newInstance() as GBase;
						contentPane.addChild(obj);
						if (obj is GButtonBase && _labelField)
							(obj as GButtonBase).labelField = _labelField;
						obj.data = data[i];
						obj.owner = self;
						obj.selected = obj.data && obj.data == selectedData;
					}
				}
			}
			layout.vaildLayout();
			
			dispatchEvent(new GEvent(GEvent.REFRESH_COMPLETE));
		}
		
		/**
		 * 单独刷新某个物体 
		 * @param i
		 * 
		 */
		public function renderItem(i:int):void
		{
			if (i < contentPane.numChildren)
			{
				var obj:GBase = getChildAt(i) as GBase;
				if (obj)
					obj.data = data[i];
			}
		}
		
		/**
		 * 单独刷新某个数据
		 * @param i
		 * 
		 */
		public function renderData(v:*):void
		{
			var index:int = data.indexOf(v);
			if (index != -1)
				renderItem(index)
		}
		
		/**
		 * 由数据获得对象
		 * @param v
		 * 
		 */
		public function getRender(v:*):DisplayObject
		{
			var index:int = data.indexOf(v);
			if (index != -1)
				return getChildAt(index)
			else
				return null;
		}
		
		/** @inheritDoc*/
		public override function set data(v:*) : void
		{
			super.data = v;
			render();
		}
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (destoryed)
				return;
			
			ref = null;
			renderSkin = null;
			
			for (var i:int = 0; i < contentPane.numChildren;i++)
			{
				if (contentPane.getChildAt(i) is IGBase)
					(contentPane.getChildAt(i) as IGBase).destory();
			}
			contentPane.removeEventListener(MouseEvent.CLICK,clickHandler);
		
			super.destory();
		}
		
		/**
		 * 点击事件 
		 * @param event
		 * 
		 */
		protected function clickHandler(event:MouseEvent):void
		{
			if (event.target == contentPane)
				return;
			
			var o:DisplayObject = event.target as DisplayObject;
			while (o && o.parent != contentPane)
				o = o.parent;
			
			if (ref.isClass(o))
			{
				var e:ItemClickEvent = new ItemClickEvent(ItemClickEvent.ITEM_CLICK);
				e.data = (o as GBase).data;
				e.relatedObject = o as InteractiveObject;
				dispatchEvent(e);
			}
		}
		
		/**
		 * 按钮条的label字段
		 * @return 
		 * 
		 */
		public function get labelField():String
		{
			return _labelField;
		}
		
		public function set labelField(v:String):void
		{
			_labelField = v;
			for (var i:int = 0;i < contentPane.numChildren;i++)
			{
				var obj:GButtonBase = contentPane.getChildAt(i) as GButtonBase;
				if (obj)
				{
					obj.labelField = labelField;
					obj.data = obj.data;
				}
			}
		}
		
		/**
		 * 按钮点击事件
		 * @param event
		 * 
		 */
		protected function itemClickHandler(event:ItemClickEvent):void
		{
			if (toggleOnClick && event.data)
				selectedData = event.data;
		}
		
		/**
		 * 选择的索引 
		 * @return 
		 * 
		 */
		public function get selectedIndex():int
		{
			return data.indexOf(selectedData);
		}
		
		public function set selectedIndex(v:int):void
		{
			if (v == -1)
				selectedData = null;
			else
				selectedData = data[v];
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
			if (_selectedData == v)
				return;
			
			_selectedData = v;
			
			if (toggle || toggleOnClick)
			{
				for (var i:int = 0;i < contentPane.numChildren;i++)
				{
					var item:GBase = contentPane.getChildAt(i) as GBase;
					if (item)
						item.selected = v && item.data == v; 
				}
			}
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * 选择的按钮
		 * @return 
		 * 
		 */
		public function get selectedChild():DisplayObject
		{
			return contentPane.getChildAt(selectedIndex);
		}
		
		public function set selectedChild(v:DisplayObject):void
		{
			selectedIndex = contentPane.getChildIndex(v);
		}
	}
}