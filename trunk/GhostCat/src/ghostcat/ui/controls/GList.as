package ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import ghostcat.display.viewport.Tile;
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
		}
		
		public override function setContent(skin:DisplayObject, replace:Boolean=true) : void
		{
			super.setContent(skin,replace);
			
			this.width = skin.width;
			this.height = skin.height;
		}
		
		protected override function get contentRect():Rectangle
		{
			var rect:Rectangle = super.contentRect.clone();
			
			if (type == HLIST)
			{
				rect.height = height;
			}
			else if (type == VLIST)
			{
				rect.width = width;
			}
			
			return rect;
		}
	}
}