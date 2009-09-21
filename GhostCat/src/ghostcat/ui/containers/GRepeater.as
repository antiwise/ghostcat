package ghostcat.ui.containers
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import ghostcat.display.DisplayUtil;
	import ghostcat.display.GBase;
	import ghostcat.display.GNoScale;
	import ghostcat.display.GSprite;
	import ghostcat.events.ItemClickEvent;
	import ghostcat.ui.layout.LinearLayout;
	import ghostcat.util.ClassFactory;
	import ghostcat.util.Util;
	
	[Event(name="item_click",type="ghostcat.events.ItemClickEvent")]
	/**
	 * 根据data复制对象排列的容器
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GRepeater extends GBox
	{
		public var ref:ClassFactory;
		
		public function GRepeater(skin:*=null, replace:Boolean=true, ref:*=null)
		{
			super(skin, replace);
			
			if (ref is Class)
				this.ref = new ClassFactory(ref)
			else if (ref is ClassFactory)
				this.ref = ref as ClassFactory;
			
			contentPane.addEventListener(MouseEvent.CLICK,clickHandler);
			
		}
		
		public override function set data(v:*) : void
		{
			super.data = v;
			
			DisplayUtil.removeAllChildren(contentPane);
			
			for (var i:int = 0;i < data.length;i++)
			{
				var obj:GBase = ref.newInstance() as GBase;
				contentPane.addChild(obj);
				obj.data = data[i];
			}
			layout.invalidateLayout();
		}

		public override function destory() : void
		{
			super.destory();
			
			for (var i:int = 0; i < contentPane.numChildren;i++)
			{
				if (contentPane.getChildAt(i) is GSprite)
					(contentPane.getChildAt(i) as GSprite).destory();
			}
			contentPane.removeEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		protected function clickHandler(event:MouseEvent):void
		{
			if (event.target == contentPane)
				return;
			
			var o:DisplayObject = event.target as DisplayObject;
			while (o.parent != contentPane)
				o = o.parent;
			
			if (ref.isClass(o))
				dispatchEvent(Util.createObject(new ItemClickEvent(ItemClickEvent.ITEM_CLICK),{item:(o as GBase).data,relatedObject:o}));
		}
		
	}
}