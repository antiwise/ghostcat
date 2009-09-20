package ghostcat.ui.containers
{
	import ghostcat.ui.controls.GButton;

	[Event(name="item_click",type="ghostcat.events.ItemClickEvent")]
	public class GButtonBar extends GRepeater
	{
		public function GButtonBar(skin:*=null, replace:Boolean=true,ref:* = null)
		{
			if (!ref)
				ref = GButton;
			
			super(skin, replace,ref);
		}
	}
}