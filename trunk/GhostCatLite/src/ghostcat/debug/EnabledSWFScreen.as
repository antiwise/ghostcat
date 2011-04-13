package ghostcat.debug
{
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import ghostcat.display.GSprite;
	import ghostcat.util.Tick;
	import ghostcat.util.easing.TweenUtil;
	
	/**
	 * 在鼠标不在屏幕内时将帧数设置为0
	 * @author flashyiyi
	 * 
	 */
	public class EnabledSWFScreen extends GSprite
	{
		private var _enabled:Boolean = false;
		private var oldFrameRate:int;
		
		public var showHandler:Function;
		public var hideHandler:Function;
		
		public function EnabledSWFScreen(stage:Stage,showHandler:Function = null,hideHandlder:Function = null)
		{
			this.showHandler = showHandler;
			this.hideHandler = hideHandlder;
			
			stage.addChild(this);
		}
		
		/**
		 * 是否激活暂停 
		 * @return 
		 * 
		 */
		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			if (!stage)
				return;
			
			if (_enabled == value)
				return;
			
			_enabled = value;
			
			TweenUtil.removeTween(this);
			
			if (value)
			{
				stage.frameRate = oldFrameRate;
				Tick.instance.clear();
				TweenUtil.to(this,400,{autoAlpha:0.0});
				
				if (showHandler!=null)
					showHandler();
			}
			else
			{
				TweenUtil.to(this,400,{autoAlpha:1.0,onComplete:onTweenComplete});
			
				if (hideHandler!=null)
					hideHandler();
			}
		}
		
		private function onTweenComplete():void
		{
			stage.frameRate = 0;
		}

		
		protected override function init():void
		{
			oldFrameRate = stage.frameRate;
			stage.frameRate = 0;
			
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0xFFFFFF);
			shape.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			shape.graphics.endFill();
			shape.blendMode = BlendMode.ADD;
			addChild(shape);
			
			var textField:TextField = new TextField();
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.text = "鼠标移入开始播放";
			textField.x = (stage.stageWidth - textField.width) / 2 + 30;
			textField.y = (stage.stageHeight - textField.height) / 2;
			textField.blendMode = BlendMode.LAYER;
			addChild(textField);
			
			var logo:GhostCatLogo = new GhostCatLogo();
			logo.x = textField.x - logo.width + 20;
			logo.y = textField.y - logo.height / 2;
			addChild(logo);
			
			stage.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			stage.addEventListener(Event.MOUSE_LEAVE,mouseLeaveHandler);
		}
		
		private function mouseOverHandler(event:MouseEvent):void
		{
			enabled = true;
		}
		
		private function mouseLeaveHandler(event:Event):void
		{
			enabled = false;
		}
		
		public override function destory() : void
		{
			if (destoryed)
				return;
			
			stage.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			stage.removeEventListener(Event.MOUSE_LEAVE,mouseLeaveHandler);
			
			super.destory();
		}
	}
}