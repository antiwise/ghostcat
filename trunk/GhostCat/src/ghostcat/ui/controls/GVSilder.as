package ghostcat.ui.controls
{
	import ghostcat.ui.UIConst;
	

	public class GVSilder extends GSilder
	{
		public function GVSilder(skin:* =null, replace:Boolean=true, fields:Object=null)
		{
			super(skin, replace, fields);
			
			this.direction = UIConst.VERTICAL;
		}
	}
}