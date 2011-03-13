package ghostcat.display.bitmap
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	import ghostcat.display.IGBase;
	import ghostcat.events.GEvent;
	import ghostcat.events.MoveEvent;
	import ghostcat.events.ResizeEvent;
	import ghostcat.events.TickEvent;
	import ghostcat.parse.display.DrawParse;
	import ghostcat.parse.graphics.GraphicsBitmapFill;
	import ghostcat.util.Tick;
	import ghostcat.util.core.ClassFactory;
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
		 * 是否在销毁时回收位图
		 */
		public var disposeWhenDestory:Boolean = true;
		
		/**
		 * 是否已经被销毁
		 */
		public var destoryed:Boolean = false;
		
		/**
		 * 是否允许缩放BitmapData
		 */
		public var enabledScale:Boolean = false;
		
		/**
		 * 是否在第一次设置content时接受content的坐标 
		 */		
		public var acceptContentPosition:Boolean = true;
		
		/**
		 * 内容是否初始化
		 */
		protected var contentInited:Boolean = false;
		
		private var _enableMouseEvent:Boolean = false;
		
		private var _oldPosition:Point = new Point();
		private var _position:Point = new Point();
		
		private var _width:Number;
		private var _height:Number;
		
		private var _bitmapData:BitmapData;
		
		/**
		 * 鼠标事件对象
		 */
		public var bitmapMouseChecker:BitmapMouseChecker;
		
		/**
		 * 位图缓存对象 
		 */
		public var bitmapByteArrayCacher:BitmapByteArrayCacher;
		
		public function GBitmap(skin:*=null, pixelSnapping:String="auto", smoothing:Boolean=false, replace:Boolean=true)
		{
			super(null, pixelSnapping, smoothing);
			
			if (skin)
				setContent(skin,replace);
			
			if (bitmapData)
			{
				_width = bitmapData.width;
				_height = bitmapData.height;
			}
			
			addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler);
		}
		
		/**
		 * 设置皮肤。
		 * 
		 * @param skin		皮肤	
		 * @param replace	是否替换原图元
		 * 
		 */		
		public function setContent(skin:*,replace:Boolean=true):void
		{
			if (skin is String)
				skin = getDefinitionByName(skin as String);
			
			if (skin is Class)
				skin = new ClassFactory(skin);
			
			if (skin is ClassFactory)
				skin = (skin as ClassFactory).newInstance();
			
			if (bitmapData == skin)
				return;
			
			var oldIndex:int;
			var oldParent:DisplayObjectContainer;
			
			if (replace && skin && skin is DisplayObject)
			{
				//新设置内容的时候，获取内容的坐标
				if (acceptContentPosition && !contentInited)
				{
					this.x = skin.x;
					this.y = skin.y;
				}
				
				if (bitmapData == null)
				{
					//加入舞台
					if (skin.parent)
					{
						oldParent = skin.parent;
						oldIndex = skin.parent.getChildIndex(skin);
					}
				}
				
				if (!contentInited)
				{
					this.visible = skin.visible;
					this.name = skin.name;
				}
			}
			
			if (skin is Bitmap)
				bitmapData = (skin as Bitmap).bitmapData;
			else if (skin is DisplayObject)
				bitmapData = new DrawParse(skin as DisplayObject).createBitmapData();
			else if (skin is BitmapData)
				bitmapData = skin as BitmapData;
			
			if (oldParent && !(oldParent is Loader))
				oldParent.addChildAt(this,oldIndex);
			
			this.contentInited = true;
		}
		
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
			
			if (bitmapData)
			{
				_width = bitmapData.width;
				_height = bitmapData.height;
				
				if (bitmapByteArrayCacher)
					cache();
			}
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
		
		private var _owner:DisplayObject;
		
		/** @inheritDoc */	
		public function get owner():DisplayObject
		{
			return _owner;
		}
		
		public function set owner(value:DisplayObject):void
		{
			_owner = value;
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
		public function setPosition(p:Point,noEvent:Boolean = false):void
		{
			var displayPoint:Point = new Point(super.x,super.y);
			if (!displayPoint.equals(p))
			{
				_oldPosition = displayPoint;
				position = p;
				
				if (!delayUpatePosition)
				{
					super.x = p.x;
					super.y = p.y
				}
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
		
		/**
		 * 缓存成ByteArray，在BitmapScreen中显示时，重新执行cache前位图不会变更
		 * 
		 */
		public function cache():void
		{
			bitmapByteArrayCacher = new BitmapByteArrayCacher(_bitmapData);
		}
		
		/**
		 * 解除缓存
		 * 
		 */
		public function uncache():void
		{
			bitmapByteArrayCacher = null;
		}
		
		/** @inheritDoc*/
		public function drawToBitmapData(target:BitmapData,offest:Point):void
		{
			if (bitmapData)
			{
				if (bitmapByteArrayCacher)
					bitmapByteArrayCacher.drawToBitmapData(target,position.add(offest));
				else
					target.copyPixels(bitmapData,bitmapData.rect,position.add(offest),null,null,true);
			}
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
			
			if (bitmapData && disposeWhenDestory)
			{
				bitmapData.dispose();
				bitmapData = null;
			}
			
			removeEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler);
		
			if (parent)
				parent.removeChild(this);
			
			destoryed = true;
		}
		
	}
}