package ghostcat.ui.validators
{
	import flash.geom.Point;
	
	import ghostcat.text.RegExpUtil;
	
	public class GEmailValidator extends GRegexpValidator
	{
		public function GEmailValidator(skin:*=null, source:Object=null, property:String=null, replace:Boolean=true, separateTextField:Boolean=false, textPos:Point=null)
		{
			super(skin, source, property, /^[\D]([\w-]+)?@[\w-]+\.[\w-]+(\.[\w-]{2,4})?$/, replace, separateTextField, textPos);
		}
	}
}