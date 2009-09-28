package ghostcat
{
	import ghostcat.display.GSprite;
	import ghostcat.manager.InputManager;
	import ghostcat.manager.RootManager;
	import ghostcat.ui.CursorSprite;
	import ghostcat.ui.PopupManager;
	import ghostcat.ui.ToolTipSprite;
	
	/**
	 * 可以通过让文档类继承此类来快速构筑应用
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GApplication extends GSprite
	{
		public var cursorSprite:CursorSprite;
		public var toolTipSprite:ToolTipSprite;
		protected override function init():void
		{
			RootManager.register(this);
			InputManager.register(this);
			
			cursorSprite = new CursorSprite()
			stage.addChild(cursorSprite);
			
			toolTipSprite = new ToolTipSprite();
			stage.addChild(toolTipSprite);
		}
	}
}