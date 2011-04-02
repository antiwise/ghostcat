package ghostcat.ui.controls
{
	import ghostcat.ui.UIConst;
	import ghostcat.ui.containers.GListBase;

	/**
	 * 兼容性保留
	 * @author flashyiyi
	 * 
	 */
	public class GListBase extends ghostcat.ui.containers.GListBase
	{
		public function GListBase(skin:*=null,replace:Boolean = true, type:String = UIConst.VERTICAL,itemRender:* = null)
		{
			super(skin,replace,type,itemRender);
		}
	}
}