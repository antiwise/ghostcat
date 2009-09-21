package ghostcat.ui.containers
{
	import ghostcat.ui.UIConst;
	import ghostcat.ui.layout.AbsoluteLayout;
	import ghostcat.ui.layout.LinearLayout;

	public class GHBox extends GBox
	{
		public function GHBox(skin:*=null, replace:Boolean=true)
		{
			super(skin, replace);
			type = UIConst.HORIZONTAL;
		}
	}
}