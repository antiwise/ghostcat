package org.ghostcat.skin.code
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import org.ghostcat.core.ClassFactory;
	import org.ghostcat.display.GBase;
	import org.ghostcat.util.Geom;
	
	public class ToolTipSkin extends GBase
	{
		public static var defaultSkin:ClassFactory = new ClassFactory(ArowSkin);
		
		public function ToolTipSkin(skin:DisplayObject=null)
		{
			if (!skin)
				skin = defaultSkin.newInstance();
			
			super(skin);
		}
		
		public function setTarget(target:DisplayObject):void
		{
			var rect:Rectangle = Geom.getRect(target,this.parent);
			this.x = rect.bottom + 5;
			this.y = rect.left + rect.width / 2;
		}
	}
}