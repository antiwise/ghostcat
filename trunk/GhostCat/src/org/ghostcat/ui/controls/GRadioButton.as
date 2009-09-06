package org.ghostcat.ui.controls
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import org.ghostcat.skin.RadioButtonIconSkin;
	import org.ghostcat.util.ClassFactory;
	
	public class GRadioButton extends GButton
	{
		public static var defaultSkin:ClassFactory = new ClassFactory(RadioButtonIconSkin);
		
		public function GRadioButton(skin:MovieClip=null, replace:Boolean=true)
		{
			if (!skin)
				skin = defaultSkin.newInstance();
				
			this.textPos = new Point(15,0);
			this.toggle = true;
			
			super(skin, replace);
		}
	}
}