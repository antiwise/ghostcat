package ghostcat.display.bitmap
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import ghostcat.display.IGBase;
	import ghostcat.events.GEvent;
	import ghostcat.events.MoveEvent;
	import ghostcat.events.ResizeEvent;
	import ghostcat.events.TickEvent;
	import ghostcat.util.Tick;
	import ghostcat.util.Util;
	import ghostcat.util.core.CallLater;
	
	[Event(name="update_complete",type="ghostcat.events.GEvent")]
	
	[Event(name="move",type="ghostcat.events.MoveEvent")]
	
	[Event(name="resize",type="ghostcat.events.ResizeEvent")]
	
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
		
		/**
		 * 旧的位置坐标 
		 */		
		public var oldPosition:Point = new Point();
		
		private var _position:Point = new Point();
		
		public function GBitmap(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(bitmapData, pixelSnapping, smoothing);
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
		
		/** @inheritDoc*/
		public override function set bitmapData(value:BitmapData) : void
		{
			super.bitmapData = value;
			
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
			invalidateSize();
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
			invalidateSize();
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
		 * @inheritDoc
		 */
		public function invalidateSize():void
		{
			CallLater.callLater(updateSize,null,true);
		}
		
		/**
		 * @inheritDoc
		 */
		public function invalidateDisplayList():void
		{
			CallLater.callLater(updateDisplayList,null,true);
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
			if (!noEvent)
				updateSize();
			dispatchEvent(Util.createObject(new ResizeEvent(ResizeEvent.RESIZE),{size:new Point(width,height)}));
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
		}
		
		/** @inheritDoc*/
		public function drawBitmapData(target:BitmapData):void
		{
			if (bitmapData)
				target.copyPixels(bitmapData,bitmapData.rect,position);
		}
		
		/**
		 * 销毁方法 
		 * 
		 */
		public function destory():void
		{
			if (destoryed)
				return;
			
			if (parent)
				parent.removeChild(this);
			
			if (bitmapData)
				bitmapData.dispose();
			
			removeEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler);
		
			destoryed = true;
		}
		
	}
}