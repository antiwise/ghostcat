package org.ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	
	import org.ghostcat.skin.VScrollBarSkin;
	import org.ghostcat.util.ClassFactory;
	
	/**
	 * 纵向滚动条
	 *  
	 * @author flashyiyi
	 * 
	 */
	public class GVScrollBar extends GScrollBar
	{
		public static var defaultSkin:ClassFactory = new ClassFactory(VScrollBarSkin);
		
		public function GVScrollBar(skin:DisplayObject=null, replace:Boolean=true)
		{
			if (!skin)
				skin = defaultSkin.newInstance();
			
			super(skin, replace);
		}
	}
}