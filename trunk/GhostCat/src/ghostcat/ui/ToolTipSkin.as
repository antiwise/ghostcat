package ghostcat.ui
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import ghostcat.skin.ArowSkin;
	import ghostcat.ui.controls.GText;
	import ghostcat.util.ClassFactory;
	
	/**
	 * IToolTipSkin的默认实现
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ToolTipSkin extends GText implements IToolTipSkin
	{
		public static var defaultSkin:ClassFactory = new ClassFactory(ArowSkin);
		
		public function ToolTipSkin(skin:*=null)
		{
			if (!skin)
				skin = defaultSkin;
			super(skin,true,true,new Point(2,2));
		}
		
		public function positionTo(target:DisplayObject):void
		{
			var toolTipSprite:ToolTipSprite = this.parent as ToolTipSprite;
			toolTipSprite.x = toolTipSprite.parent.mouseX + 15;
			toolTipSprite.y = toolTipSprite.parent.mouseY + 15;
		}
	}
}