package ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import ghostcat.display.viewport.Tile;
	import ghostcat.util.ClassFactory;
	import ghostcat.util.SearchUtil;
	
	public class List extends Tile
	{
		public static const TILE:String = "tile";
		public static const HLIST:String = "hlist";
		public static const VLIST:String = "vlist";
		
		public static var defaultSkin:ClassFactory = new ClassFactory(GText);
		
		public var type:String = TILE;
		
		public function List(skin:DisplayObject,renderField:String = "render")
		{
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
				
			super(render);
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