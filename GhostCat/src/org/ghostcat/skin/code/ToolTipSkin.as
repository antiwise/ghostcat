package org.ghostcat.skin.code
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import org.ghostcat.core.ClassFactory;
	import org.ghostcat.ui.IToolTipSkin;
	import org.ghostcat.ui.controls.GText;
	import org.ghostcat.util.Geom;
	
	/**
	 * 默认ToolTip
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ToolTipSkin extends GText implements IToolTipSkin
	{
		public static var defaultSkin:ClassFactory = new ClassFactory(ArowSkin);
		
		public function ToolTipSkin(skin:DisplayObject=null)
		{
			if (!skin)
				skin = defaultSkin.newInstance();
			super(skin);
		
			this.adjustSize = true;
			this.mouseEnabled = this.mouseChildren = false;
		}
		
		public function setTarget(target:DisplayObject):void
		{
			var rect:Rectangle = Geom.getRect(target,this.parent);
			this.x = rect.bottom + 5;
			this.y = rect.left + rect.width / 2;
		}
	}
}