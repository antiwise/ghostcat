package ghostcat.ui
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import ghostcat.display.GBase;
	import ghostcat.display.IDisplayObject;
	import ghostcat.display.IToolTipManagerClient;
	import ghostcat.ui.tooltip.IToolTipSkin;
	import ghostcat.ui.tooltip.ToolTipSkin;
	import ghostcat.util.core.ClassFactory;
	import ghostcat.util.Util;

	/**
	 * 提示类
	 * 实现IToolTipManagerClient即可启用
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ToolTipSprite extends GBase
	{
		public static var defaultSkin:ClassFactory = new ClassFactory(ToolTipSkin);
		/**
		 * 延迟显示的毫秒数 
		 */		
		public var delay:int = 500;
		
		/**
		 * 连续显示间隔的毫秒数 
		 */		
		public var cooldown:int = 250;
		
		/**
		 * 限定触发提示的类型
		 */
		public var onlyWithClasses:Array;
		
		/**
		 * ToolTip目标
		 */		
		public var target:DisplayObject;
		
		/**
		 * 默认ToolTipClass
		 */		
		public var defaultObj:IToolTipSkin;
		
		private var toolTipObjs:Object;//已注册的ToolTipObj集合
		
		private var delayTimer:Timer;//延迟显示计时器
		
		private var delayCooldown:Timer;//连续显示计时器
		
		private static var _instance:ToolTipSprite;
		
		/**
		 * 皮肤必须为IToolTipSkin
		 * 
		 * @param obj
		 * 
		 */
		public function ToolTipSprite(obj:IToolTipSkin=null)
		{
			if (!obj)
				obj = defaultSkin.newInstance();
				
			defaultObj = obj;
				
			super();
			
			this.acceptContentPosition = false;
			this.mouseEnabled = this.mouseChildren = false;
			
			if (!_instance)
				_instance = this;
		}
		
		public static function get instance():ToolTipSprite
		{
			return _instance;
		}
		
		public function get obj():GBase
		{
			return content as GBase;
		}
		
		/**
		 * 注册一个ToolTipObj
		 * 
		 * @param name	名称
		 * @param v	对象
		 * 
		 */		
		public function registerToolTipObj(name:String,v:GBase):void
		{
			toolTipObjs[name] = v;
		}
		
		/**
		 * 设置内容
		 * @return 
		 * 
		 */		
		public override function get data():*
		{
			return obj.data;
		}

		public override function set data(v:*):void
		{
			obj.data = v;
		}

		protected override function init() : void
		{
			super.init();
			stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			stage.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
		}
		
		private function mouseMoveHandler(event:MouseEvent):void
		{
			if (content && target)
				(content as IToolTipSkin).positionTo(target);
		}
		
		private function mouseOutHandler(event:MouseEvent):void
		{
			hide();
		}
		
		private function mouseOverHandler(event:MouseEvent):void
		{
			target = findToolTipTarget(event.target as DisplayObject);
			
			if (target)
				delayShow(delay);
			else
				hide();
		}
		
		private function findToolTipTarget(displayObj : DisplayObject) : DisplayObject
		{
			var currentTarget:DisplayObject = displayObj;
			
			while (currentTarget && currentTarget.parent != currentTarget)
			{
				if (currentTarget is IToolTipManagerClient 
					&& (currentTarget as IToolTipManagerClient).toolTip 
					&& (onlyWithClasses == null || Util.isIn(cursor,onlyWithClasses)))
					return currentTarget;
				
				currentTarget = currentTarget.parent;
			}
			return null;
		}
		
		/**
		 * 延迟显示
		 * @param t	时间
		 * 
		 */		
		public function delayShow(t:int):void
		{
			if (delayCooldown){
				delayCooldown.delay = 0;
				t = 0;
			}
			
			if (delayTimer){
				delayTimer.delay = t;
			}else{
				delayTimer = new Timer(t,1);
				delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,show);
				delayTimer.start();
			}
		}
		
		private function show(event:TimerEvent):void
		{
			delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,show);
			delayTimer = null;
			
			if (target is IToolTipManagerClient)
			{
				var client:IToolTipManagerClient = target as IToolTipManagerClient;
				showToolTip(target,client.toolTip,client.toolTipObj);
			}
		}
		
		/**
		 * 显示出ToolTip
		 * 
		 * @param target	目标
		 * @param toolTip
		 * @param toolTipObj	
		 * 
		 */
		public function showToolTip(target:DisplayObject,toolTip:*,toolTipObj:*=null):void
		{
			this.target = target;
			
			var obj:* = toolTipObj;
			if (obj is String)
				obj = toolTipObjs[obj];
			
			if (obj is Class)
				obj = new obj();
			
			if (!obj)
				obj = defaultObj;
			
			setContent(obj);
			(content as IToolTipSkin).data = toolTip;
			(content as IToolTipSkin).show(target);
			
			mouseMoveHandler(null);
		}
		
		/**
		 * 隐藏提示 
		 * 
		 */		
		public function hide():void
		{
			setContent(null);
			
			if (delayCooldown){
				delayCooldown.delay = cooldown;
			}else{
				delayCooldown = new Timer(cooldown,1);
				delayCooldown.addEventListener(TimerEvent.TIMER_COMPLETE,removeCooldown);
				delayCooldown.start();
			}
		}
		
		private function removeCooldown(event:TimerEvent):void
		{
			delayCooldown.removeEventListener(TimerEvent.TIMER_COMPLETE,show);
			delayCooldown = null;
		}
		
		
		public override function destory() : void
		{
			super.destory();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			stage.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
		}
	}
}
