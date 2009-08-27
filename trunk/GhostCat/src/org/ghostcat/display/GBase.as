package org.ghostcat.display
{
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import org.ghostcat.core.GSprite;
	import org.ghostcat.events.GEvent;
	import org.ghostcat.events.MoveEvent;
	import org.ghostcat.events.ResizeEvent;
	import org.ghostcat.util.CallLater;
	import org.ghostcat.util.Util;
	
	[Event(name="update_complete",type="org.ghostcat.events.GEvent")]
	
	[Event(name="move",type="org.ghostcat.events.MoveEvent")]
	
	[Event(name="resize",type="org.ghostcat.events.ResizeEvent")]
	
	/**
	 * 这个类并不是专门针对UI的。事实上，就算是普通的显示对象，一样有设置toolTip和cursor的需求，UI和非UI的区分并没有那么大。
	 * 而这种程度的内存增加是完全可以接受的。真需要严格控制性能的时候，也应该使用Bitmap,Shape之类的东西。
	 * 
	 * collision和oldPosition则主要针对于游戏
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class GBase extends GSprite implements IGBase
	{
		private var _enabled:Boolean = true;
		
		private var _cursor:*;
		
		private var _toolTip:*;
		
		private var _toolTipObj:*;
		
		private var _data:Object;
		
		/**
		 * 旧的位置坐标 
		 */		
		public var oldPosition:Point = new Point();
		
		private var _position:Point = new Point();
		
		/**
		 * 是否延迟更新坐标。如果延迟更新，将不会出现设置了属性值屏幕却不能立即看到表现导致错位的情况，
		 * 因为整个过程都被延后了。但这样画面会延后一帧，会产生画面拖慢，因此只在必要的时候使用
		 */		
		public var delayUpatePosition:Boolean = false;
		
		
		/**
		 * 参数与setContent方法相同
		 * 
		 */		
		public function GBase(skin:DisplayObject=null,replace:Boolean=true)
		{
			super(skin,replace);
		}
		
		/**
		 * 设置数据 
		 * @return 
		 * 
		 */		
		public function get data():*
		{
			return _data;
		}

		public function set data(v:*):void
		{
			_data = v;
		}
		
		/**
		 * 提示的内容，不一定非要是字符串，以便实现复杂内容的提示
		 * 此属性在GToolTipSprite不存在实例时无效
		 * @return 
		 * 
		 */		
		public function get toolTip():*
		{
			return _toolTip;
		}

		public function set toolTip(v:*):void
		{
			_toolTip = v;
		}
		/**
		 * 提示的自定义显示，用于单个控件特殊的提示，可多个组件共享同一个实例。类型只能是字符串或者GBase对象。
		 * 当类型是字符串时，将会从GToolTipSprite查找已注册的ToolTipObj。都不满足时，将使用GToolTipSprite的默认提示
		 * 
		 * 此属性在GToolTipSprite不存在实例时无效
		 * @return 
		 * 
		 */		

		public function get toolTipObj():*
		{
			return _toolTipObj;
		}

		public function set toolTipObj(v:*):void
		{
			_toolTipObj = v;
		}
		/**
		 * 光标的Class，可能的类型是Class或者String，Class类型直接是显示的图元，
		 * String类型时，将会从GCursorSprite的cursors对象中寻找对应的Class;
		 * 
		 * 当GCursorSprite类不存在实例时，此属性无效
		 * 
		 * @return 
		 * 
		 */		
		public function get cursor():*
		{
			return _cursor;
		}

		public function set cursor(v:*):void
		{
			_cursor = v;
		}

		/**
		 *
		 * 是否激活 
		 * @return 
		 * 
		 */
		 		
		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(v:Boolean):void
		{
			_enabled = v;
		}
		
		public override function set x(value:Number):void
		{
			if (x == value)
				return;
			
			oldPosition.x = super.x;
			position.x = value;
			
			if (!delayUpatePosition)
				super.x = value;
			
			invalidatePosition();
		}
		
		public override function get x() : Number
		{
			return position.x;
		}
		
		public override function set y(value:Number):void
		{
			if (y == value)
				return;
			
			oldPosition.y = super.y;
			position.y = value;
		
			if (!delayUpatePosition)
				super.y = value;
				
			invalidatePosition();
		}
		
		public override function get y() : Number
		{
			return position.y;
		}
		
		/**
		 * 设置位置坐标
		 * @param v
		 * 
		 */		
		public function set position(v:Point):void
		{
			x = v.x;
			y = v.y;
		}
		
		public function get position():Point
		{
			return _position;
		}
		
		public override function set width(value:Number):void
		{
			if (super.width == value)
				return;
			
			super.width = value;
				
			invalidateSize();
		}
		
		public override function set height(value:Number):void
		{
			if (super.height == value)
				return;
				
			super.height = value;
				
			invalidateSize();
		}
		
//		/**
//		 * 自动注册事件常量。
//		 */		
//		protected function get autoRegHandlers():Array
//		{
//			 return   [Event.ENTER_FRAME,
//						MouseEvent.CLICK,
//						MouseEvent.DOUBLE_CLICK,
//						MouseEvent.MOUSE_DOWN,
//						MouseEvent.MOUSE_MOVE,
//						MouseEvent.MOUSE_OUT,
//						MouseEvent.MOUSE_OVER,
//						MouseEvent.MOUSE_UP,
//						MouseEvent.MOUSE_WHEEL,
//						MouseEvent.ROLL_OUT,
//						MouseEvent.ROLL_OVER,
//						KeyboardEvent.KEY_DOWN,
//						KeyboardEvent.KEY_UP];
//		}
//		
//		/**
//		 * 
//		 * 自动注册事件，将自动注册符合条件的方法为事件，会在init()时自动触发。
//		 * 由于其生效机制，如果希望事件在所有派生类中都生效，事件函数应该是public或者protected，如果设成private，派生类里将不会注册这个事件。
//		 * 
//		 * 一次注册的事件将会有3个，分别对应this,parent,stage的情况，诸如：
//		 * this_clickHandler,parent_clickHandler,stage_clickHandler
//		 * 
//		 * @param remove		是否是卸除
//		 */	
//		protected function regEventHandler(remove:Boolean=false):void
//		{
//			var targetMap:Object = new Object();
//			targetMap["this"] = this;
//			if (this.parent) 
//				targetMap["parent"] = this.parent;
//			if (this.stage) 
//				targetMap["stage"] = this.stage;
//			
//			for (var i:int = 0;i < autoRegHandlers.length; i++)
//			{
//				for (var key:* in targetMap)
//				{
//					var target:EventDispatcher = targetMap[key];
//					var handler:String = key + "_" +autoRegHandlers[i] + "Handler";
//					if (hasOwnProperty(handler)){
//						if (remove){
//							target.removeEventListener(autoRegHandlers[i],this[handler]);
//						}else{
//							target.addEventListener(autoRegHandlers[i],this[handler]);
//						}
//					}
//				}
//			}
//		}
//		
		protected override function init():void
		{
			super.init();
			
			createChildren();
			
//			regEventHandler();
		}
		
		protected function createChildren():void
		{
			
		}
		
		/**
		 * 立即更新显示 
		 * 
		 */
		public function vaildNow():void
		{
			vaildPosition();
			vaildSize();
			vaildDisplayList();
		}
		
		/**
		 * 在之后更新坐标
		 * 
		 */
		public function invalidatePosition():void
		{
			CallLater.callLaterNextFrame(vaildPosition,null,true);
		}
		
		/**
		 * 在之后更新大小
		 * 
		 */
		public function invalidateSize():void
		{
			CallLater.callLaterNextFrame(vaildSize,null,true);
		}
		
		/**
		 * 在之后更新显示
		 * 
		 */
		public function invalidateDisplayList():void
		{
			CallLater.callLater(vaildDisplayList,null,true);
		}
		
		
		/**
		 * 更新坐标并发事件
		 * 
		 */
		public function vaildPosition():void
		{
			super.x = position.x;
			super.y = position.y;			
		
			updatePosition();
			
			dispatchEvent(Util.createObject(new MoveEvent(MoveEvent.MOVE),{oldPosition:oldPosition,newPosition:position}));
			oldPosition = position.clone();
		}
		
		/**
		 * 更新大小并发事件 
		 * 
		 */
		public function vaildSize():void
		{
			updateSize();
			dispatchEvent(Util.createObject(new ResizeEvent(ResizeEvent.RESIZE),{size:new Point(width,height)}));
		}
		
		/**
		 * 更新显示并发事件 
		 * 
		 */
		public function vaildDisplayList():void
		{
			updateDisplayList();
			dispatchEvent(new GEvent(GEvent.UPDATE_COMPLETE));
		}
		
		/**
		 * 更新位置的操作
		 * 
		 */
		protected function updatePosition():void
		{
		}
		
		/**
		 * 更新大小的操作
		 * 
		 */
		protected function updateSize():void
		{
		}
		
		/**
		 * 更新显示的操作
		 * 
		 */
		protected function updateDisplayList(): void
		{
		}
		
		private var _refreshInterval:int = 0;
		private var _refreshTimer:Timer;
		
		/**
		 * 自动刷新间隔，默认为不刷新 
		 * @return 
		 * 
		 */
		public function get refreshInterval():int
		{
			return _refreshInterval;
		}

		public function set refreshInterval(v:int):void
		{
			if (_refreshInterval == v)
				return;
			
			_refreshInterval = v;
			if (v == 0)
			{
				if (_refreshTimer)
				{
					_refreshTimer.removeEventListener(TimerEvent.TIMER,refreshHandler);
					_refreshTimer.stop();
					_refreshTimer = null;
				}
			}
			else
			{
				if (!_refreshTimer)
				{
					_refreshTimer = new Timer(v,int.MAX_VALUE);
					_refreshTimer.addEventListener(TimerEvent.TIMER,refreshHandler);
					_refreshTimer.start();
				}
				else
					_refreshTimer.delay = v;
			}
		}
		
		private function refreshHandler(event:TimerEvent):void
		{
			invalidateDisplayList();
		}
		
//		public override function destory():void
//		{
//			regEventHandler(false);
//			super.destory();
//		}
		
	}
}