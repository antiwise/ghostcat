package org.ghostcat.ui
{
	import flash.display.DisplayObject;
	
	import org.ghostcat.core.ClassFactory;
	import org.ghostcat.ui.controls.GText;
	import org.ghostcat.skin.code.ArowSkin;
	
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
		}
		
		public function positionTo(target:DisplayObject):void
		{
			var toolTipSprite:ToolTipSprite = this.parent as ToolTipSprite;
			toolTipSprite.x = toolTipSprite.parent.mouseX + 15;
			toolTipSprite.y = toolTipSprite.parent.mouseY + 15;
		}
	}
}