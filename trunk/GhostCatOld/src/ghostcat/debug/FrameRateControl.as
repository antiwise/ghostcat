package ghostcat.debug
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import ghostcat.display.GBase;
	import ghostcat.manager.InputManager;
	import ghostcat.skin.FrameRateSkin;
	import ghostcat.ui.PopupManager;
	import ghostcat.ui.UIBuilder;
	import ghostcat.ui.controls.GButton;
	import ghostcat.ui.controls.GCheckBox;
	import ghostcat.ui.controls.GHSilder;
	import ghostcat.ui.controls.GText;
	import ghostcat.ui.layout.AbsoluteLayout;
	import ghostcat.util.core.ClassFactory;
	import ghostcat.util.data.LocalStorage;
	import ghostcat.util.display.Geom;
	
	/**
	 * 帧数控制
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class FrameRateControl extends GBase
	{
		public static var defaultSkin:ClassFactory = new ClassFactory(FrameRateSkin)
		
		private static var timer:Timer;
		private static var oldFrameRate:int = 0;
		private static var _checkInactive:Boolean = false;
		
		private static var checkInactiveLocal:LocalStorage = new LocalStorage("ghostcatCheckInactive");
		private static var frameRateLocal:LocalStorage = new LocalStorage("ghostcatFrameRate");
		
		private static var frameRateStage:Stage;
		
		/**
		 * 注册舞台，提供帧数控制功能 
		 * @param stage
		 * 
		 */
		public static function register(stage:Stage):void
		{
			frameRateStage = stage;
			checkInactive = checkInactiveLocal.getValue();
			
			var frame:int = frameRateLocal.getValue();
			if (frame > 0)
				stage.frameRate = frame;
		}
		
		/**
		 * 显示面板
		 * 
		 */
		public static function showPanel():void
		{
			if (!frameRateStage)
				Debug.error("请先执行register方法注册舞台");
				
			var v:FrameRateControl = new FrameRateControl();
			frameRateStage.addChild(v);
			Geom.centerIn(v,frameRateStage);
			
			PopupManager.createTempCover(v);//创建临时的背景遮挡
		}
		
		/**
		 * 是否处理暂离 
		 */
		public static function get checkInactive():Boolean
		{
			return _checkInactive;
		}

		public static function set checkInactive(value:Boolean):void
		{
			if (_checkInactive == value)
				return;
			
			_checkInactive = value;
			
			if (value)
			{
				timer = new Timer(1000);
				timer.addEventListener(TimerEvent.TIMER,inactiveHandler);
				timer.start();
			}
			else
			{
				timer.addEventListener(TimerEvent.TIMER,inactiveHandler);
				timer.stop();
				timer = null;
			}
			
			checkInactiveLocal.setValue(value);
		}

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
				
				inactiveTip = new DebugRect(frameRateStage.stageWidth,16,0xF0FF0000,"播放器已进入低CPU占用模式（将鼠标移入播放器解除此模式）")
				frameRateStage.addChild(inactiveTip);
			}
			if (!ins.inactive && oldFrameRate != 0)
			{
				ins.stage.frameRate = oldFrameRate;
				oldFrameRate = 0;
				
				frameRateStage.removeChild(inactiveTip);
				inactiveTip = null;
			}
		}
		
		private static var inactiveTip:Sprite;
		
		public var silder:GHSilder;
		public var frameRateDisplayText:GText;
		public var closeButton:GButton;
		public var checkBox:GCheckBox;
		
		public var layout:AbsoluteLayout;
		
		public function FrameRateControl()
		{
			super(defaultSkin);
			
			UIBuilder.buildAll(this);
			
			silder.addEventListener(Event.CHANGE,silderChangeHandler);
			silder.minValue = 1;
			silder.maxValue = 120;
			
			checkBox.addEventListener(Event.CHANGE,checkBoxChangeHandler);
			checkBox.selected = checkInactive;
			
			closeButton.addEventListener(MouseEvent.CLICK,closeButtonClickHandler);
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
			frameRateLocal.setValue(int(silder.value));
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