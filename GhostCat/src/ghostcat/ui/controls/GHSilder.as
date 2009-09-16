package ghostcat.ui.controls
{
	import ghostcat.ui.UIConst;

	public class GHSilder extends GSilder
	{
		public function GHSilder(skin:* =null, replace:Boolean=true, fields:Object=null)
		{
			super(skin, replace, fields);
			
			this.direction = UIConst.HORIZONTAL;
		}
	}
}