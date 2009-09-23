package ghostcat.ui.containers
{
	import ghostcat.ui.layout.LinearLayout;
	
	public class GBox extends GView
	{
		public function GBox(skin:* = null, replace:Boolean=true)
		{
			super(skin, replace);
			
			layout = new LinearLayout(contentPane);
		}
		
		public function get type():String
		{
			return (layout as LinearLayout).type;
		}

		public function set type(v:String):void
		{
			(layout as LinearLayout).type = v;
		}
	}
}