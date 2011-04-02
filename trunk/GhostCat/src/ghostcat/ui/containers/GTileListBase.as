package ghostcat.ui.containers
{
	import ghostcat.ui.UIConst;

	/**
	 * 双向ListBase，必须设置宽度或者columnCount
	 * @author flashyiyi
	 * 
	 */
	public class GTileListBase extends GListBase
	{
		public function GTileListBase(skin:*=null, replace:Boolean=true, type:String=UIConst.TILE, itemRender:*=null)
		{
			super(skin, replace, type, itemRender);
		}
	}
}