package ghostcat.ui.tooltip
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import ghostcat.skin.ArowSkin;
	import ghostcat.ui.controls.GText;
	import ghostcat.util.core.ClassFactory;
	import ghostcat.util.easing.TweenUtil;
	import ghostcat.util.easing.Back;
	import ghostcat.util.easing.Circ;
	import ghostcat.ui.ToolTipSprite;
	
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
			
			this.enabledAdjustContextSize = true;
		}
		/** @inheritDoc*/
		public function show(target:DisplayObject):void
		{
			var toolTipSprite:ToolTipSprite = this.parent as ToolTipSprite;
			toolTipSprite.x = toolTipSprite.parent.mouseX + 10;
			toolTipSprite.y = toolTipSprite.parent.mouseY + 10;
			toolTipSprite.blendMode = BlendMode.LAYER;
			
			TweenUtil.removeTween(toolTipSprite);
			TweenUtil.from(toolTipSprite,100,{alpha:0.0,y:"10"}).update();
		}
		/** @inheritDoc*/
		public function positionTo(target:DisplayObject):void
		{
			var toolTipSprite:ToolTipSprite = this.parent as ToolTipSprite;
			toolTipSprite.x = toolTipSprite.parent.mouseX + 10;
			toolTipSprite.y = toolTipSprite.parent.mouseY + 10;
		}
	}
}