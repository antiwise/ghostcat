package ghostcat.text.controls
{
	import ghostcat.ui.controls.GGradientText;
	import ghostcat.ui.layout.Padding;
	
	/**
	 * 兼容性保留
	 * @author flashyiyi
	 * 
	 */
	public class GradientText extends ghostcat.ui.controls.GGradientText
	{
		public function GradientText(skin:*=null, replace:Boolean=true, separateTextField:Boolean=false, textPadding:Padding=null)
		{
			super(skin, replace, separateTextField, textPadding);
		}
	}
		
}