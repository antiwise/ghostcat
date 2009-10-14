package ghostcat.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import ghostcat.events.GEvent;
	import ghostcat.events.MoveEvent;
	import ghostcat.events.ResizeEvent;
	import ghostcat.events.TickEvent;
	import ghostcat.util.Tick;
	import ghostcat.util.Util;
	import ghostcat.util.core.UniqueCall;
	import ghostcat.util.display.MatrixUtil;
	
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
		
		private var _enabledTick:Boolean = false;
		
		private var _cursor:*;
		
		private var _toolTip:*;
		
		private var _toolTipObj:*;
		
		protected var _data:Object;
		
		/**
		 * 旧的位置坐标 
		 */		
		private var _oldPosition:Point = new Point();
		
		private var _position:Point = new Point();
		
		/**
		 * 是否激活各种Vaild事件（取消可大幅增加性能）
		 */
		public var enabledDelayUpdate:Boolean = true;
		
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
		
		/** @inheritDoc */	
		public function get paused():Boolean
		{
			return _paused;
		}

		public function set paused(v:Boolean):void
		{
			if (_paused == v)
				return;
			
			_paused = v;
			
			if (!_paused && _enabledTick)
				Tick.instance.addEventListener(TickEvent.TICK,tickHandler);
			else
				Tick.instance.removeEventListener(TickEvent.TICK,tickHandler);
		}
		
		/** @inheritDoc */	
		public function get enabledTick():Boolean
		{
			return _enabledTick;
		}

		public function set enabledTick(v:Boolean):void
		{
			if (_enabledTick == v)
				return;
			
			_enabledTick = v;
			
			if (!_paused && _enabledTick)
				Tick.instance.addEventListener(TickEvent.TICK,tickHandler);
			else
				Tick.instance.removeEventListener(TickEvent.TICK,tickHandler);
		}

		/** @inheritDoc */
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
			
			_oldPosition.x = super.x;
			position.x = value;
			
			if (!delayUpatePosition)
				super.x = value;
			
			if (enabledDelayUpdate)
				positionCall.invalidate();
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
			
			_oldPosition.y = super.y;
			position.y = value;
		
			if (!delayUpatePosition)
				super.y = value;
				
			if (enabledDelayUpdate)
				positionCall.invalidate();
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
				_oldPosition.x = super.x;
				position.x = x;
			
				if (!delayUpatePosition)
					super.x = x;
			}
			if (super.y != y)
			{
				_oldPosition.y = super.y;
				position.y = y;
				
				if (!delayUpatePosition)
					super.y = y;
			}
			
			if (enabledDelayUpdate)
				vaildPosition(noEvent); 
		}

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
		
		/**
		 * 旧坐标
		 * @return 
		 * 
		 */
		public function get oldPosition():Point
		{
			return _oldPosition;
		}
		
		/**
		 * 坐标变化位移
		 * @return 
		 * 
		 */
		public function get positionOffest():Point
		{
			return position.subtract(_oldPosition);
		}
		
		/** @inheritDoc*/
		public override function set width(value:Number):void
		{
			if (super.width == value)
				return;
			
			super.width = value;
				
			if (enabledDelayUpdate)
				sizeCall.invalidate();
		}
		/** @inheritDoc*/
		public override function set height(value:Number):void
		{
			if (super.height == value)
				return;
				
			super.height = value;
				
			if (enabledDelayUpdate)
				sizeCall.invalidate();
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
			if (super.width == width && super.height == height)
				return;
			
			super.width = width;
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
		
		protected var positionCall:UniqueCall = new UniqueCall(vaildPosition,true);
		protected var sizeCall:UniqueCall = new UniqueCall(vaildSize,true);
		protected var displayListCall:UniqueCall = new UniqueCall(vaildDisplayList);
		
		/**
		 * 在之后更新坐标
		 * 
		 */
		public function invalidatePosition():void
		{
			positionCall.invalidate();
		}
		
		/**
		 * 在之后更新大小
		 * 
		 */
		public function invalidateSize():void
		{
			sizeCall.invalidate();
		}
		
		/**
		 * 在之后更新显示
		 * 
		 */
		public function invalidateDisplayList():void
		{
			displayListCall.invalidate();
		}
		
		
		/**
		 * 更新坐标并发事件
		 * 
		 */
		public function vaildPosition(noEvent:Boolean = false):void
		{
			if (super.x != position.x)
				super.x = position.x;
			
			if (super.y != position.y)
				super.y = position.y;			
			
			updatePosition();
			
			if (!noEvent)
			{
				var e:MoveEvent = new MoveEvent(MoveEvent.MOVE);
				e.oldPosition = _oldPosition;
				e.newPosition = position;
				dispatchEvent(e);
			}
			_oldPosition = position.clone();
		}
		
		/**
		 * 更新大小并发事件 
		 * 
		 */
		public function vaildSize(noEvent:Boolean = false):void
		{
			updateSize();
			
			if (!noEvent)
			{
				var e:ResizeEvent = new ResizeEvent(ResizeEvent.RESIZE);
				e.size = new Point(width,height)
				dispatchEvent(e);
				
				if (parent)
				{
					e = new ResizeEvent(ResizeEvent.CHILD_RESIZE);
					e.size = new Point(width,height);
					e.child = this;
					parent.dispatchEvent(e);
				}
			}
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
		
		/**
		 * 时基事件
		 * @param event
		 * 
		 */
		protected function tickHandler(event:TickEvent):void
		{
			vaildDisplayList();
		}
		
		private var _bitmap:Bitmap;
		private var _asBitmap:Boolean = false;
		
		/**
		 * 将content替换成Bitmap,增加性能
		 * 
		 */		
		public function set asBitmap(v:Boolean):void
		{
			if (v)
			{
				content.visible = false;
				reRenderBitmap();	
			}
			else
			{
				content.visible = true;
				if (_bitmap)
				{
					_bitmap.bitmapData.dispose();
					_bitmap.parent.removeChild(_bitmap);
					_bitmap = null;
				}
			}
		}
		
		public function get asBitmap():Boolean
		{
			return _asBitmap;
		}
		
		/**
		 * 更新缓存位图
		 * 
		 */			
		public function reRenderBitmap():void
		{
			var oldRect:Rectangle = _bitmap ? _bitmap.getBounds(this) : null;
			var rect:Rectangle = content.getBounds(this);
			if (!rect.equals(oldRect))
			{
				if (_bitmap)
				{
					removeChild(_bitmap);
					_bitmap.bitmapData.dispose();
				}
				_bitmap = new Bitmap(new BitmapData(Math.ceil(rect.width),Math.ceil(rect.height),true,0));
				_bitmap.x = rect.x;
				_bitmap.y = rect.y;
				$addChild(_bitmap);
			}
			var m:Matrix = new Matrix();
			m.translate(-rect.x,-rect.y);
			_bitmap.bitmapData.draw(content,m);
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
			vaildDisplayList();
		}
		
		/** @inheritDoc*/
		public override function destory():void
		{
			if (destoryed)
				return;
			
			var evt:GEvent = new GEvent(GEvent.REMOVE,false,true)
			dispatchEvent(evt);
			
			if (evt.isDefaultPrevented())
				return;
			
			this.enabledTick = false;
			this.refreshInterval = 0;
			this.asBitmap = false;
			
			super.destory();
		}
		
	}
}