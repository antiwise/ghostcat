package ghostcat
{
	import ghostcat.debug.Debug;
	import ghostcat.display.GBase;
	import ghostcat.display.GSprite;
	import ghostcat.ui.CursorSprite;
	import ghostcat.ui.PopupManager;
	import ghostcat.ui.ToolTipSprite;

	/**
	 * GhostCatUI部分的默认文档类。此类并不是必须的。如果你愿意，可以由Sprite作为文档类，并使用GhostCat的所有功能。
	 * @author flashyiyi
	 * 
	 */
	public class GhostCatApp extends GSprite
	{
		public var worldLayer:GBase;
		public var popupLayer:GBase;
		public var cursor:CursorSprite;
		public var toolTip:ToolTipSprite;
		
		public override function get width():Number
		{
			return stage.stageWidth;
		}
		
		public override function get height():Number
		{
			return stage.stageHeight;
		}
		
		public override function set width(v:Number):void
		{
			Debug.error("不允许设置宽度");
		}
		
		public override function set height(v:Number):void
		{
			Debug.error("不允许设置高度");
		}
		
		protected override function init():void
		{
			super.init();
			
			this.cursor = new CursorSprite();
			addChild(this.cursor);
			
			this.toolTip = new ToolTipSprite();
			addChild(this.cursor);
			
			this.worldLayer = new GBase();
			addChild(this.worldLayer);
			
			this.popupLayer = new GBase();
			addChild(this.popupLayer);
			
			PopupManager.instance.register(worldLayer,popupLayer);	
		}
	}
}