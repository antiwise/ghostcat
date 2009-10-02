package ghostcat.debug
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import ghostcat.display.GSprite;
	import ghostcat.manager.DragManager;
	import ghostcat.skin.DebugPanelSkin;
	import ghostcat.ui.UIBuilder;
	import ghostcat.ui.containers.GResizePanel;
	import ghostcat.ui.controls.GButton;
	import ghostcat.ui.controls.GText;
	import ghostcat.ui.controls.GVScrollBar;
	import ghostcat.ui.layout.AbsoluteLayout;
	
	/**
	 * 显示调试信息的窗口（按Cirl+D呼出）
	 * @author flashyiyi
	 * 
	 */
	public class DebugPanel extends GResizePanel
	{
		public var debugTextField:GText;
		public var scrollBar:GVScrollBar;
		public var closeButton:GButton;
		public var background:GSprite;
		
		private var _stage:Stage;
		public function DebugPanel(stage:Stage)
		{
			_stage = stage;
			
			super(new DebugPanelSkin());
			
			UIBuilder.buildAll(this);
			
			scrollBar = new GVScrollBar();
			scrollBar.detra = 1;
			scrollBar.duration = 0;
			scrollBar.target = debugTextField.textField;
			addChild(scrollBar);
			
			layout = new AbsoluteLayout(this);
			
			(layout as AbsoluteLayout).setMetrics(background,0,0,0,0);
			(layout as AbsoluteLayout).setMetrics(debugTextField.textField,8,25,8,8);
			(layout as AbsoluteLayout).setMetrics(scrollBar,NaN,26,7,7);
			(layout as AbsoluteLayout).setMetrics(closeButton,NaN,NaN,8,NaN);
			
			DragManager.register(background,this);
			closeButton.addEventListener(MouseEvent.CLICK,closeButtonClickHandler);
			
			Debug.debugTextField = debugTextField.textField;
			
			
			this.minHeight = 80;
			this.minWidth = 50;
			this.x = (stage.stageWidth - this.width)/2;
			this.y = (stage.stageHeight - this.height)/2;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
		}
		
		private function keyDownHandler(event:KeyboardEvent):void
		{
			if (event.ctrlKey && event.keyCode == ("D").charCodeAt(0))
			{
				if (parent)
					parent.removeChild(this);
				else
					_stage.addChild(this);
			}
		}
		
		private function closeButtonClickHandler(event:MouseEvent):void
		{
			if (parent)
				parent.removeChild(this);
		}
		
		/** @inheritDoc*/
		public override function destory() : void
		{
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			closeButton.removeEventListener(MouseEvent.CLICK,closeButtonClickHandler);
			DragManager.unregister(background);
			super.destory();
		}
	}
}