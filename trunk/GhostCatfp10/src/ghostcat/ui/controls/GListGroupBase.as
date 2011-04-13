package ghostcat.ui.controls
{
	import ghostcat.ui.UIConst;
	import ghostcat.ui.containers.GListGroupBase;
	
	/**
	 * 兼容性保留
	 * @author flashyiyi
	 * 
	 */
	public class GListGroupBase extends ghostcat.ui.containers.GListGroupBase
	{
		public function GListGroupBase(skin:*=null, replace:Boolean=true, type:String=UIConst.VERTICAL, itemRender:*=null)
		{
			super(skin, replace, type, itemRender);
		}
	}
}