package org.ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	
	import org.ghostcat.skin.HScrollBarSkin;
	import org.ghostcat.util.ClassFactory;
	
	/**
	 * 横向滚动条
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GHScrollBar extends GScrollBar
	{
		public static var defaultSkin:ClassFactory = new ClassFactory(HScrollBarSkin);
		
		public function GHScrollBar(skin:DisplayObject=null, replace:Boolean=true)
		{
			if (!skin)
				skin = defaultSkin.newInstance();
			
			super(skin, replace);
		}
	}
}