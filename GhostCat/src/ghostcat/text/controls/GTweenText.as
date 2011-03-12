package ghostcat.text.controls
{
	import ghostcat.ui.controls.GTweenText;
	import ghostcat.ui.layout.Padding;
	
	/**
	 * 兼容性保留
	 * @author flashyiyi
	 * 
	 */
	public class GTweenText extends ghostcat.ui.controls.GTweenText
	{
		public function GTweenText(skin:*=null, replace:Boolean=true, separateTextField:Boolean=false, textPadding:Padding=null)
		{
			super(skin, replace, separateTextField, textPadding);
		}
	}
}