package ghostcat
{
	import ghostcat.debug.Debug;
	import ghostcat.display.GBase;
	import ghostcat.display.GSprite;
	import ghostcat.ui.CursorSprite;
	import ghostcat.ui.PopupManager;
	import ghostcat.ui.ToolTipSprite;

	/**
	 * GhostCatUI部分的默认文档类。此类并不是必须的。
	 * @author flashyiyi
	 * 
	 */
	public class GhostCatApp extends GSprite
	{
		public var application:GBase;
		public var popupLayer:GBase;
		public var cursor:CursorSprite;
		public var toolTip:ToolTipSprite;
		
		public override function get width():Number
		{
			return 745;
		}
		
		public override function get height():Number
		{
			return 660;
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
			
			this.application = new GBase();
			addChild(this.application);
			
			this.popupLayer = new GBase();
			addChild(this.popupLayer);
			
			this.toolTip = new ToolTipSprite();
			addChild(this.toolTip);
			
			this.cursor = new CursorSprite();
			addChild(this.cursor);
			
			PopupManager.instance.register(application,popupLayer);	
		}
	}
}