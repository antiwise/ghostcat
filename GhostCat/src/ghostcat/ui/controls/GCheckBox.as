package ghostcat.ui.controls
{
	import ghostcat.skin.CheckBoxIconSkin;
	import ghostcat.ui.layout.Padding;
	import ghostcat.util.core.ClassFactory;
	
	/**
	 * 多选框
	 * 
	 * 标签规则：当作按钮转换
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GCheckBox extends GButton
	{
		public static var defaultSkin:* = CheckBoxIconSkin;
		
		/**
		 * 值
		 */
		public var value:*;
		
		public function GCheckBox(skin:*=null, replace:Boolean=true, separateTextField:Boolean = false, textPadding:Padding=null)
		{
			if (!skin)
				skin = defaultSkin;
				
			if (!textPadding)
				textPadding = new Padding(15,0);
			
			this.toggle = true;
			
			super(skin, replace,separateTextField,textPadding);
		}
	}
}