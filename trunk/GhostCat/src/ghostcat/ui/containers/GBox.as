package ghostcat.ui.containers
{
	import flash.display.DisplayObjectContainer;
	
	import ghostcat.display.GNoScale;
	import ghostcat.ui.containers.GView;
	import ghostcat.ui.layout.AbsoluteLayout;
	import ghostcat.ui.layout.Layout;
	import ghostcat.ui.layout.LinearLayout;
	
	public class GBox extends GView
	{
		public var layout:LinearLayout;
		
		public function GBox(skin:* = null, replace:Boolean=true)
		{
			super(skin, replace);
			
			layout = new LinearLayout(contentPane);
		}
		
		public function get type():String
		{
			return layout.type;
		}

		public function set type(v:String):void
		{
			layout.type = v;
		}
	}
}