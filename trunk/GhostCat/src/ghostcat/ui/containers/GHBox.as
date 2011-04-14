package ghostcat.ui.containers
{
	import ghostcat.ui.UIConst;

	/**
	 * 横向Box
	 * @author flashyiyi
	 * 
	 */
	public class GHBox extends GBox
	{
		public function GHBox(skin:*=null, replace:Boolean=true)
		{
			super(skin, replace);
			type = UIConst.HORIZONTAL;
		}
	}
}