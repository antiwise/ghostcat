package ghostcat.ui.containers
{
	import ghostcat.ui.UIConst;

	/**
	 * 双向Box，必须设置宽度
	 * @author flashyiyi
	 * 
	 */
	public class GTileBox extends GBox
	{
		public function GTileBox(skin:*=null, replace:Boolean=true)
		{
			super(skin, replace);
			this.type = UIConst.TILE;
		}
	}
}