package ghostcat.ui.containers
{
	import ghostcat.ui.UIConst;
	import ghostcat.ui.layout.AbsoluteLayout;
	import ghostcat.ui.layout.LinearLayout;

	/**
	 * 纵向Box
	 * @author flashyiyi
	 * 
	 */
	public class GVBox extends GBox
	{
		public function GVBox(skin:*=null, replace:Boolean=true)
		{
			super(skin, replace);
			type = UIConst.VERTICAL;
		}
	}
}