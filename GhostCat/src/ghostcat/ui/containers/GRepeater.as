package ghostcat.ui.containers
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import ghostcat.display.GBase;
	import ghostcat.display.IGBase;
	import ghostcat.events.ItemClickEvent;
	import ghostcat.ui.layout.LinearLayout;
	import ghostcat.util.core.ClassFactory;
	import ghostcat.util.display.DisplayUtil;
	
	[Event(name="item_click",type="ghostcat.events.ItemClickEvent")]
	
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
		
		public var renderSkin:ClassFactory;
		
		public function GRepeater(skin:*=null, replace:Boolean=true, ref:*=null,type:String = "horizontal")
		{
			super(skin, replace);
			
			setContent(new Sprite());//重新设置Content，避免冲突
			setLayout(new LinearLayout());
			
			if (skin is DisplayObject)
				skin = skin["constructor"];
				
			if (skin is Class)
				this.renderSkin = new ClassFactory(skin)
			else if (ref is ClassFactory)
				this.renderSkin = skin as ClassFactory;
				
			if (ref is Class)
				this.ref = new ClassFactory(ref)
			else if (ref is ClassFactory)
				this.ref = ref as ClassFactory;
			
			contentPane.addEventListener(MouseEvent.CLICK,clickHandler);
			
			this.data = [];
			
		}
		
		public function get itemRender():ClassFactory
		{
			return ref;
		}
		
		public function set itemRender(v:ClassFactory):void
		{
			this.ref = v;
			render();
		}
		
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
			
			for (i = 0;i < data.length;i++)
			{
				var obj:GBase = ref.newInstance() as GBase;
				contentPane.addChild(obj);
				obj.data = data[i];
				obj.owner = self;
			}
			layout.vaildLayout();
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
				e.item = (o as GBase).data;
				e.relatedObject = o as InteractiveObject;
				dispatchEvent(e);
			}
		}
		
	}
}