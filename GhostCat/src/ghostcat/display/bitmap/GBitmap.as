package ghostcat.display.bitmap
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import ghostcat.display.IGBase;
	import ghostcat.events.GEvent;
	import ghostcat.events.MoveEvent;
	import ghostcat.events.ResizeEvent;
	import ghostcat.events.TickEvent;
	import ghostcat.parse.display.DrawParse;
	import ghostcat.util.Tick;
	import ghostcat.util.core.UniqueCall;
	import ghostcat.util.display.GraphicsUtil;
	
	[Event(name="update_complete",type="ghostcat.events.GEvent")]
	[Event(name="click",type="ghostcat.events.MoveEvent")]
	[Event(name="move",type="ghostcat.events.MoveEvent")]
	[Event(name="resize",type="ghostcat.events.ResizeEvent")]
	[Event(name="rollOver",type="flash.events.MouseEvent")]
	[Event(name="rollOut",type="flash.events.MouseEvent")]
	[Event(name="mouseOver",type="flash.events.MouseEvent")]
	[Event(name="mouseOut",type="flash.events.MouseEvent")]
	[Event(name="mouseDown",type="flash.events.MouseEvent")]
	[Event(name="mouseUp",type="flash.events.MouseEvent")]
	
	
	/**
	 * 此类默认会在修改大小后会自动调整Bitmapdata的大小，采用裁剪而不是缩放
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GBitmap extends Bitmap implements IGBase,IBitmapDataDrawer
	{
		private var _enabled:Boolean = true;
		
		private var _paused:Boolean = false;
		
		private var _enabledTick:Boolean = false;
		
		private var _cursor:*;
		
		private var _toolTip:*;
		
		private var _toolTipObj:*;
		
		private var _data:Object;
		
		/**
		 * 是否激活各种Vaild事件（取消可大幅增加性能）
		 */
		public var enabledDelayUpdate:Boolean = true;
		
		/**
		 * 是否延迟更新坐标
		 */
		public var delayUpatePosition:Boolean = false;
		
		/**
		 * 是否在移出显示列表的时候删除自身
		 */		
		public var destoryWhenRemove:Boolean = false;
		
		/**
		 * 是否已经被销毁
		 */
		public var destoryed:Boolean = false;
		
		/**
		 * 是否允许缩放BitmapData
		 */
		public var enabledScale:Boolean = false;
		
		private var _enableMouseEvent:Boolean = true;
		
		private var _oldPosition:Point = new Point();
		
		private var _position:Point = new Point();
		
		/**
		 * 鼠标事件对象
		 */
		public var bitmapMouseChecker:BitmapMouseChecker;
		
		public function GBitmap(source:*=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			if (source is Bitmap)
				source = (source as Bitmap).bitmapData;
			else if (source is DisplayObject)
				source = new DrawParse(source as DisplayObject).createBitmapData();
			
			super(source, pixelSnapping, smoothing);
			
			if (bitmapData)
			{
				_width = bitmapData.width;
				_height = bitmapData.height;
			}
			
			addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler);
		}
		
		private var _width:Number;
		private var _height:Number;
		
		private var _bitmapData:BitmapData;
		
		/**
		 * 是否激活模拟鼠标事件
		 * @return 
		 * 
		 */
		public function get enableMouseEvent():Boolean
		{
			return _enableMouseEvent;
		}

		public function set enableMouseEvent(value:Boolean):void
		{
			_enableMouseEvent = value;
			if (bitmapMouseChecker)
				bitmapMouseChecker.enabled = value;
		}

		/** @inheritDoc*/
		public override function set bitmapData(value:BitmapData) : void
		{
			_bitmapData = super.bitmapData = value;
			
			_width = bitmapData.width;
			_height = bitmapData.height;
		}
		
		/** @inheritDoc */
		public function get data():*
		{
			return _data;
		}

		public function set data(v:*):void
		{
			_data = v;
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
		
		public var priority:int = 0;
		
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
				Tick.instance.addEventListener(TickEvent.TICK,tickHandler,false,priority);
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
		
		/**
		 * 旧的位置坐标 
		 */		
		public function get oldPosition():Point
		{
			return _oldPosition;
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
		
		/** @inheritDoc */
		public function get toolTip():*
		{
			return _toolTip;
		}

		public function set toolTip(v:*):void
		{
			_toolTip = v;
		}
		
		/** @inheritDoc */
		public function get toolTipObj():*
		{
			return _toolTipObj;
		}

		public function set toolTipObj(v:*):void
		{
			_toolTipObj = v;
		}
		
		/** @inheritDoc */
		public function get cursor():*
		{
			return _cursor;
		}

		public function set cursor(v:*):void
		{
			_cursor = v;
		}
		
		/** @inheritDoc */
		public override function get width() : Number
		{
			return _width;
		}
		
		/** @inheritDoc */
		public override function set width(v:Number):void
		{
			if (_width == v)
				return;
			
			_width = v;
			if (enabledDelayUpdate)
				sizeCall.invalidate();
		}

		/** @inheritDoc */
		public override function get height() : Number
		{
			return _height;
		}
		
		/** @inheritDoc */
		public override function set height(v:Number):void
		{
			if (_height == v)
				return;
				
			_height = v;
			if (enabledDelayUpdate)
				sizeCall.invalidate();
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
		 * @inheritDoc
		 */
		public function invalidateSize():void
		{
			sizeCall.invalidate();
		}
		
		/**
		 * @inheritDoc
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
			if (!noEvent)
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
		
		protected function updateSize():void
		{
			if (enabledScale)
			{
				super.width = width;
				super.height = height;
			}
			else
			{
				var newBitmapData:BitmapData = new BitmapData(_width,_height,true,0);
				if (bitmapData)
				{
					newBitmapData.copyPixels(bitmapData,bitmapData.rect,new Point());
					bitmapData.dispose();
				}
				bitmapData = newBitmapData;
			}
		}
		
		/**
		 * 更新显示 
		 * 
		 */
		protected function updateDisplayList(): void
		{
		}
		
		private var _refreshInterval:int = 0;
		private var _refreshTimer:Timer;
		
		/**
		 * 时基事件
		 * @param event
		 * 
		 */
		protected function tickHandler(event:TickEvent):void
		{
			invalidateDisplayList();
		}
		
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
		
		private function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,addedToStageHandler)
			init();
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			if (destoryWhenRemove)
				destory();
		}
		
		/**
		 *
		 * 初始化方法，在第一次被加入显示列表时调用 
		 * 
		 */		
		protected function init():void
		{
			bitmapMouseChecker = new BitmapMouseChecker(this); 
			bitmapMouseChecker.enabled = _enableMouseEvent;
		}
		
		/** @inheritDoc*/
		public function drawToBitmapData(target:BitmapData,offest:Point):void
		{
			if (bitmapData)
				target.copyPixels(bitmapData,bitmapData.rect,position.add(offest));
		}
		
		/** @inheritDoc*/
		public function drawToShape(target:Graphics,offest:Point):void
		{
			var p:Point = new Point(x,y).add(offest);
			GraphicsUtil.drawBitmpData(target,bitmapData,p.x,p.y);
		}
		
		
		/** @inheritDoc*/
		public function getBitmapUnderMouse(mouseX:Number,mouseY:Number):Array
		{
			return (uint(bitmapData.getPixel32(mouseX - x,mouseY - y) >> 24) > 0) ? [this] : null;
		}
		
		/**
		 * 销毁方法 
		 * 
		 */
		public function destory():void
		{
			if (destoryed)
				return;
			
			if (bitmapMouseChecker)
				bitmapMouseChecker.destory();
			
			if (bitmapData)
				bitmapData.dispose();
			
			
			removeEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler);
		
			if (parent)
				parent.removeChild(this);
			
			destoryed = true;
		}
		
	}
}