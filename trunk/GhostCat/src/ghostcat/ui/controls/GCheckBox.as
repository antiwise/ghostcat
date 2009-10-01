package ghostcat.ui.controls
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import ghostcat.skin.CheckBoxIconSkin;
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
		public static var defaultSkin:ClassFactory = new ClassFactory(CheckBoxIconSkin);
		
		/**
		 * 值
		 */
		public var value:*;
		
		public function GCheckBox(skin:*=null, replace:Boolean=true, separateTextField:Boolean = false, textPos:Point=null)
		{
			if (!skin)
				skin = defaultSkin;
				
			if (!textPos)
				textPos = new Point(15,0);
			
			this.toggle = true;
			
			super(skin, replace,separateTextField,textPos);
		}
	}
}