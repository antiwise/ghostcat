package ghostcat.debug
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import ghostcat.display.GBase;
	import ghostcat.manager.InputManager;
	import ghostcat.skin.FrameRateSkin;
	import ghostcat.ui.UIBuilder;
	import ghostcat.ui.controls.GButton;
	import ghostcat.ui.controls.GCheckBox;
	import ghostcat.ui.controls.GHSilder;
	import ghostcat.ui.controls.GText;
	import ghostcat.ui.layout.AbsoluteLayout;
	import ghostcat.util.Tick;
	import ghostcat.util.core.ClassFactory;
	import ghostcat.util.display.Geom;
	
	public class FrameRatePanel extends GBase
	{
		public static var defaultSkin:ClassFactory = new ClassFactory(FrameRateSkin)
		/**
		 * 是否处理暂离 
		 */
		public static var checkInactive:Boolean = false;
		
		private static var timer:Timer = new Timer(1000);
		timer.addEventListener(TimerEvent.TIMER,inactiveHandler);
		timer.start();
		
		private static var oldFrameRate:int = 0;
		private static function inactiveHandler(event:TimerEvent):void
		{
			if (!checkInactive)
				return;
				
			var ins:InputManager = InputManager.instance;
			if (!ins)
				return;
			
			if (ins.inactive && oldFrameRate == 0)
			{
				oldFrameRate = ins.stage.frameRate;
				ins.stage.frameRate = 1;
			}
			if (!ins.inactive && oldFrameRate != 0)
			{
				ins.stage.frameRate = oldFrameRate;
				oldFrameRate = 0;
			}
		}
		
		public var silder:GHSilder;
		public var frameRateDisplayText:GText;
		public var closeButton:GButton;
		public var checkBox:GCheckBox;
		
		public var layout:AbsoluteLayout;
		
		public function FrameRatePanel(skin:*=null)
		{
			if (!skin)
				skin = defaultSkin;
			
			super(skin);
			
			UIBuilder.buildAll(this);
			
			silder.addEventListener(Event.CHANGE,silderChangeHandler);
			silder.minValue = 1;
			silder.maxValue = 120;
			
			checkBox.addEventListener(Event.CHANGE,checkBoxChangeHandler);
			checkBox.selected = checkInactive;
			
			closeButton.addEventListener(MouseEvent.CLICK,closeButtonClickHandler);
		}
		
		public static function show(target:DisplayObjectContainer):void
		{
			var v:FrameRatePanel = new FrameRatePanel();
			target.addChild(v);
			Geom.centerIn(v,target);
		}
		
		protected override function init() : void
		{
			super.init();
			
			silder.value = stage.frameRate;
			
			layout = new AbsoluteLayout(stage,true);
			layout.setCenter(this,0,0);
		}
		
		private function silderChangeHandler(event:Event):void
		{
			stage.frameRate = int(silder.value);
			frameRateDisplayText.text = stage.frameRate.toString();
		}
		
		private function checkBoxChangeHandler(event:Event):void
		{
			checkInactive = checkBox.selected;
		}
		
		private function closeButtonClickHandler(event:MouseEvent):void
		{
			destory();
		}
		
		public override function destory() : void
		{
			if (destoryed)
				return;
			
			layout.destory();
			
			silder.removeEventListener(Event.CHANGE,silderChangeHandler);
			checkBox.removeEventListener(Event.CHANGE,checkBoxChangeHandler);
			closeButton.removeEventListener(MouseEvent.CLICK,closeButtonClickHandler);
			
			UIBuilder.destory(this);
			
			super.destory();
		}
	}
}