package ghostcat.ui.validators
{
	import ghostcat.ui.layout.Padding;
	
	/**
	 * 邮件地址验证器
	 * @author flashyiyi
	 * 
	 */
	public class GEmailValidator extends GRegexpValidator
	{
		public function GEmailValidator(skin:*=null, source:Object=null, property:String=null, replace:Boolean=true, separateTextField:Boolean=false, textPadding:Padding=null)
		{
			super(skin, source, property, /^[\D]([\w-]+)?@[\w-]+\.[\w-]+(\.[\w-]{2,4})?$/, replace, separateTextField, textPadding);
		}
	}
}