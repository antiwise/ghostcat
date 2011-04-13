package ghostcat.ui
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import ghostcat.skin.ArowSkin;
	import ghostcat.ui.controls.GText;
	import ghostcat.ui.layout.Padding;
	import ghostcat.core.util.ClassFactory;
	import ghostcat.util.easing.TweenUtil;
	
	/**
	 * IToolTipSkin的默认实现
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ToolTipSkin extends Sprite implements IToolTipSkin
	{
		public var textField:TextField;
		public function ToolTipSkin(skin:*=null)
		{
			super(skin);
		
			this.enabledAutoLayout(new Padding(2,2,2,2));
		}
		
		/** @inheritDoc*/
		public function show(target:DisplayObject):void
		{
			var toolTipSprite:ToolTipSprite = this.parent as ToolTipSprite;
			toolTipSprite.x = toolTipSprite.parent.mouseX + 10;
			toolTipSprite.y = toolTipSprite.parent.mouseY + 10;
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