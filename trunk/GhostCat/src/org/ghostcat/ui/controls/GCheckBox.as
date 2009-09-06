package org.ghostcat.ui.controls
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import org.ghostcat.skin.CheckBoxIconSkin;
	import org.ghostcat.util.ClassFactory;
	
	public class GCheckBox extends GButton
	{
		public static var defaultSkin:ClassFactory = new ClassFactory(CheckBoxIconSkin);
		
		public function GCheckBox(skin:MovieClip=null, replace:Boolean=true)
		{
			if (!skin)
				skin = defaultSkin.newInstance();
			
			this.textPos = new Point(15,0);
			this.toggle = true;
			
			super(skin, replace);
		}
	}
}