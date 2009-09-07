package org.ghostcat.ui.controls
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import org.ghostcat.skin.CheckBoxIconSkin;
	import org.ghostcat.util.ClassFactory;
	
	/**
	 * 多选框
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
		
		public function GCheckBox(skin:MovieClip=null, replace:Boolean=true, textPos:Point=null)
		{
			if (!skin)
				skin = defaultSkin.newInstance();
				
			if (!textPos)
				this.textPos = new Point(15,0);
			
			this.toggle = true;
			
			super(skin, replace);
		}
	}
}