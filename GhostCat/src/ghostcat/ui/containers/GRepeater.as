package ghostcat.ui.containers
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import ghostcat.display.GBase;
	import ghostcat.display.GNoScale;
	import ghostcat.display.GSprite;
	import ghostcat.events.ItemClickEvent;
	import ghostcat.ui.layout.LinearLayout;
	import ghostcat.util.Util;
	import ghostcat.util.core.ClassFactory;
	import ghostcat.util.display.DisplayUtil;
	
	[Event(name="item_click",type="ghostcat.events.ItemClickEvent")]
	/**
	 * 根据data复制对象排列的容器
	 * 
	 * 标签规则：子对象的render将会被作为子对象的默认skin，其余部分照常显示并会被作为自己的初始大小
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GRepeater extends GBox
	{
		public var ref:ClassFactory;
		
		public var fields:Object = {renderField:"render"};
		public var renderSkin:ClassFactory;
		
		public function GRepeater(skin:*=null, replace:Boolean=true, ref:*=null)
		{
			if (fields)
				this.fields = fields;
			
			if (ref is Class)
				this.ref = new ClassFactory(ref)
			else if (ref is ClassFactory)
				this.ref = ref as ClassFactory;
			
			super(skin, replace);
			
			contentPane.addEventListener(MouseEvent.CLICK,clickHandler);
			
			this.data = [];
			
		}
		/** @inheritDoc*/
		public override function setContent(skin:*, replace:Boolean=true) : void
		{
			super.setContent(skin,replace);
			
			var renderField:String = fields.renderField;
			if (renderField && content.hasOwnProperty(renderField))
				renderSkin = new ClassFactory(content[renderField].constructor);
		}
		/** @inheritDoc*/
		public override function set data(v:*) : void
		{
			super.data = v;
			
			if (ref && renderSkin)
			{
				if (ref.params)
					ref.params[0] = renderSkin;
				else
					ref.params = [renderSkin];
			}
			
			DisplayUtil.removeAllChildren(contentPane);
			
			for (var i:int = 0;i < data.length;i++)
			{
				var obj:GBase = ref.newInstance() as GBase;
				contentPane.addChild(obj);
				obj.data = data[i];
			}
			layout.invalidateLayout();
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
				if (contentPane.getChildAt(i) is GSprite)
					(contentPane.getChildAt(i) as GSprite).destory();
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
			while (o.parent != contentPane)
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