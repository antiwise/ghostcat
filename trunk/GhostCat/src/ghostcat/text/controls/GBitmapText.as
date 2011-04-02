package ghostcat.text.controls
{
	import ghostcat.ui.controls.GBitmapText;
	import ghostcat.ui.layout.Padding;
	
	/**
	 * 兼容性保留
	 * @author flashyiyi
	 * 
	 */
	public class GBitmapText extends ghostcat.ui.controls.GBitmapText
	{
		public function GBitmapText(skin:*=null, replace:Boolean=true, separateTextField:Boolean=false, textPadding:Padding=null)
		{
			super(skin, replace, separateTextField, textPadding);
		}
	}
}