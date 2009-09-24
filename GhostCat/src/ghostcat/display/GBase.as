package ghostcat.display
{
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import ghostcat.events.GEvent;
	import ghostcat.events.MoveEvent;
	import ghostcat.events.ResizeEvent;
	import ghostcat.events.TickEvent;
	import ghostcat.util.CallLater;
	import ghostcat.util.Tick;
	import ghostcat.util.Util;
	
	[Event(name="update_complete",type="ghostcat.events.GEvent")]
	
	[Event(name="move",type="ghostcat.events.MoveEvent")]
	
	[Event(name="resize",type="ghostcat.events.ResizeEvent")]
	
	/**
	 * 这个类实现了光标和提示接口，以及属性变化事件
	 * 
	 * 建议全部可视对象都以此类作为基类，而不仅仅是组件。
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class GBase extends GSprite implements IGBase
	{
		private var _enabled:Boolean = true;
		
		private var _selected:Boolean = false;
		
		private var _paused:Boolean = false;
		
		private var _cursor:*;
		
		private var _toolTip:*;
		
		private var _toolTipObj:*;
		
		protected var _data:Object;
		
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
		public function GBase(skin:*=null,replace:Boolean=true)
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
		 * 是否选中
		 * 
		 * @return 
		 * 
		 */
		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(v:Boolean):void
		{
			_selected = v;
		}
		
		/**
		 * 是否暂停
		 * @return 
		 */		
		public function get paused():Boolean
		{
			return _paused;
		}

		public function set paused(v:Boolean):void
		{
			_paused = v;
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
		/** @inheritDoc*/
		public override function set visible(value:Boolean) : void
		{
			if (value == visible)
				return;
				
			var evt:GEvent;
			if (value)
				evt = new GEvent(GEvent.SHOW,false,true)
			else
				evt = new GEvent(GEvent.HIDE,false,true)
				
			dispatchEvent(evt);
			if (evt.isDefaultPrevented())
				return;
			
			super.visible = value;
		}
		/** @inheritDoc*/
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
		/** @inheritDoc*/
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
		 * 设置坐标
		 *  
		 * @param x	x坐标
		 * @param y	y坐标
		 * @param noEvent	是否触发事件
		 * 
		 */
		public function setPosition(x:Number,y:Number,noEvent:Boolean = false):void
		{
			if (super.x != x)
			{
				oldPosition.x = super.x;
				position.x = x;
			
				if (!delayUpatePosition)
					super.x = x;
			}
			if (super.y != y)
			{
				oldPosition.y = super.y;
				position.y = y;
				
				if (!delayUpatePosition)
					super.y = y;
			}
			
			vaildPosition(noEvent); 
		}
		
//		/**
//		 * 设置这组属性不会延迟显示和触发updatePosition,以及MOVE事件
//		 * @param v
//		 * 
//		 */
//		public function set $x(value:Number):void
//		{
//			if ($x == value)
//				return;
//			
//			oldPosition.x = super.x;
//			position.x = value;
//			
//			super.x = value;
//		}
//		
//		public function get $x():Number
//		{
//			return super.x;
//		}
//		
//		public function set $y(value:Number):void
//		{
//			if ($y == value)
//				return;
//			
//			oldPosition.y = super.y;
//			position.y = value;
//		
//			super.y = value;
//		}
//		
//		public function get $y():Number
//		{
//			return super.y;
//		}

		/**
		 * 坐标 
		 * @param v
		 * 
		 */
		public function set position(v:Point):void
		{
			setPosition(v.x,v.y);
		}
		
		public function get position():Point
		{
			return _position;
		}
		/** @inheritDoc*/
		public override function set width(value:Number):void
		{
			if (super.width == value)
				return;
			
			super.width = value;
				
			invalidateSize();
		}
		/** @inheritDoc*/
		public override function set height(value:Number):void
		{
			if (super.height == value)
				return;
				
			super.height = value;
				
			invalidateSize();
		}
		
		/**
		 * 设置大小 
		 * @param width	宽度
		 * @param height	高度
		 * @param noEvent	是否触发事件
		 * 
		 */
		public function setSize(width:Number,height:Number,noEvent:Boolean = false):void
		{
			if (super.width != width)
				super.width = width;
			
			if (super.height != height)
				super.height = height;
				
			vaildSize(noEvent);
		}
		
		/**
		 * 大小 
		 * @return 
		 * 
		 */
		public function get size():Point
		{
			return new Point(width,height);
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
		public function vaildPosition(noEvent:Boolean = false):void
		{
			super.x = position.x;
			super.y = position.y;			
		
			updatePosition();
			
			if (!noEvent)
				dispatchEvent(Util.createObject(new MoveEvent(MoveEvent.MOVE),{oldPosition:oldPosition,newPosition:position}));
			oldPosition = position.clone();
		}
		
		/**
		 * 更新大小并发事件 
		 * 
		 */
		public function vaildSize(noEvent:Boolean = false):void
		{
			updateSize();
			if (!noEvent)
				dispatchEvent(Util.createObject(new ResizeEvent(ResizeEvent.RESIZE),{size:new Point(width,height)}));
		}
		
		/**
		 * 更新显示并发事件 
		 * 
		 */
		public function vaildDisplayList(noEvent:Boolean = false):void
		{
			updateDisplayList();
			if (!noEvent)
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
		/** @inheritDoc*/
		public override function destory():void
		{
			var evt:GEvent = new GEvent(GEvent.REMOVE,false,true)
			dispatchEvent(evt);
			
			if (evt.isDefaultPrevented())
				return;
			
			super.destory();
		}
		
	}
}