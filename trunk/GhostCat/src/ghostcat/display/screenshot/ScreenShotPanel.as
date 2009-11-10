package ghostcat.display.screenshot
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import ghostcat.debug.DebugRect;
	import ghostcat.display.GBase;
	import ghostcat.display.graphics.ScaleBox;
	import ghostcat.display.graphics.SelectRect;
	import ghostcat.events.TickEvent;
	import ghostcat.parse.graphics.GraphicsFill;
	import ghostcat.parse.graphics.GraphicsLineStyle;
	import ghostcat.util.display.BitmapUtil;
	
	/**
	 * 截屏窗口 
	 * @author flashyiyi
	 * 
	 */
	public class ScreenShotPanel extends GBase
	{
		private var screen:Bitmap;
		private var layer:Sprite;
		private var selectRect:Sprite;
		private var scaleBox:ScaleBox;
		
		public var rHandler:Function;
		public var result:BitmapData;
		
		private var panel:Sprite;
		
		public function ScreenShotPanel(v:Stage,withOut:Array = null,rHandler:Function=null)
		{
			super();
			
			this.rHandler = rHandler;
			
			screen = new Bitmap(ScreenShotUtil.showScreen(v,withOut));
			addChild(screen);
			
			v.addChild(this);
			
			layer = new Sprite();
			layer.blendMode = BlendMode.SUBTRACT;
			addChild(layer);
			
			var blackLayer:Shape = new Shape();
			blackLayer.graphics.beginFill(0xFFFFFF,0.3);
			blackLayer.graphics.drawRect(0,0,v.stageWidth,v.stageHeight);
			blackLayer.graphics.endFill();
			layer.addChild(blackLayer);
			
			selectRect = new SelectRect(selectHandler,new GraphicsLineStyle(0,0x0000FF),new GraphicsFill(0xFFFFFF));
			selectRect.blendMode = BlendMode.ERASE;
			(selectRect as SelectRect).createTo(layer);
			
			panel = new DebugRect(100,20,0x0,"双击或回车截图",0xFFFFFF);
			addChild(panel);
			
			this.enabledTick = true;
		}
		
		private function selectHandler(rect:Rectangle):void
		{
			(selectRect as SelectRect).destory();
			
			selectRect = new Sprite();
			selectRect.graphics.beginFill(0xFFFFFF);
			selectRect.graphics.drawRect(0,0,rect.width,rect.height);
			selectRect.graphics.endFill();
			selectRect.blendMode = BlendMode.ERASE;
			selectRect.x = rect.x;
			selectRect.y = rect.y;
			layer.addChild(selectRect);
			
			scaleBox = new ScaleBox(selectRect);
			scaleBox.fillControl.doubleClickEnabled = true;
			scaleBox.fillControl.addEventListener(MouseEvent.DOUBLE_CLICK,doubleClickHandler);
			addChild(scaleBox);
		
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
		}
		
		private function doubleClickHandler(event:MouseEvent):void
		{
			getBitmapData();
		}
		
		private function keyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.ENTER)
				getBitmapData()
			
			if (event.keyCode == Keyboard.ESCAPE)
				destory();
		}
		
		private function getBitmapData():void
		{
			scaleBox.fillControl.removeEventListener(MouseEvent.DOUBLE_CLICK,doubleClickHandler);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			
			result = BitmapUtil.clip(screen.bitmapData,scaleBox.getRect(this))
				
			dispatchEvent(new Event(Event.COMPLETE));	
				
			if (rHandler != null)
				rHandler(result);
			
			destory();
		}
		
		protected override function tickHandler(event:TickEvent) : void
		{
			var rect:Rectangle = selectRect.getRect(this);
			panel.x = rect.x;
			panel.y = rect.y - panel.height - 5;
		}
	}
}