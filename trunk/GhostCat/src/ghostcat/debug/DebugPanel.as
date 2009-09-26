package ghostcat.debug
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	
	import ghostcat.ui.containers.GResizePanel;
	import ghostcat.ui.layout.AbsoluteLayout;
	import ghostcat.util.Util;
	
	/**
	 * 显示调试信息的窗口（按Cirl+D呼出）
	 * @author flashyiyi
	 * 
	 */
	public class DebugPanel extends GResizePanel
	{
		public var textField:TextField;
		public var layout:AbsoluteLayout;
		
		private var _stage:Stage;
		public function DebugPanel(stage:Stage)
		{
			_stage = stage;
			
			textField = Util.createObject(TextField,{background:true,border:true}) as TextField;
			super(textField);
			
			layout = new AbsoluteLayout(this);
			layout.setMetrics(textField,5,5,5,5);
			
			Debug.debugTextField = textField;
			
			this.width = 200;
			this.height = 150;
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
		
		protected override function updateSize() : void
		{
			super.updateSize();
			layout.invalidateLayout();
		}
		
		public override function destory() : void
		{
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			super.destory();
		}
	}
}