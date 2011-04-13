package ghostcat.ui.containers
{
	import ghostcat.ui.UIConst;

	/**
	 * 纵向ListBase 
	 * @author flashyiyi
	 * 
	 */
	public class GVListBase extends GListBase
	{
		public function GVListBase(skin:*=null, replace:Boolean=true, type:String=UIConst.VERTICAL, itemRender:*=null)
		{
			super(skin, replace, type, itemRender);
		}
	}
}