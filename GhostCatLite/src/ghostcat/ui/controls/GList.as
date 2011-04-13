package ghostcat.ui.controls
{
	import ghostcat.ui.UIConst;
	import ghostcat.ui.containers.GList;

	/**
	 * 兼容性保留
	 * @author flashyiyi
	 * 
	 */
	public class GList extends ghostcat.ui.containers.GList
	{
		public function GList(skin:*=null,replace:Boolean = true, type:String = UIConst.VERTICAL,itemRender:* = null,fields:Object = null)
		{
			super(skin,replace,type,itemRender,fields);
		}
	}
}