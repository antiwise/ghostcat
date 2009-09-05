package org.ghostcat.bitmap
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import org.ghostcat.events.GEvent;
	import org.ghostcat.events.ResizeEvent;
	import org.ghostcat.util.CallLater;
	import org.ghostcat.util.Util;
	
	/**
	 * 此类默认会在修改大小后会自动调整Bitmapdata的大小，采用裁剪而不是缩放
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GBitmap extends Bitmap
	{
		/**
		 * 是否在移出显示列表的时候删除自身
		 */		
		public var destoryWhenRemove:Boolean = false;
		
		/**
		 * 是否允许缩放BitmapData
		 */
		public var enabledScale:Boolean = false;
		
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
		
		/**
		 * @inheritDoc
		 */
		public override function set bitmapData(value:BitmapData) : void
		{
			super.bitmapData = value;
			_width = bitmapData.width;
			_height = bitmapData.height;
		}
		
		/**
		 * @inheritDoc
		 */
		public override function get width() : Number
		{
			return _width;
		}
		
		/**
		 * @inheritDoc
		 */
		public override function set width(v:Number):void
		{
			if (_width == v)
				return;
			
			_width = v;
			invalidateSize();
		}

		/**
		 * @inheritDoc
		 */
		public override function get height() : Number
		{
			return _height;
		}
		
		/**
		 * @inheritDoc
		 */
		public override function set height(v:Number):void
		{
			if (_height == v)
				return;
				
			_height = v;
			invalidateSize();
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
		
		/**
		 * @inheritDoc
		 */
		public function destory():void
		{
			if (parent)
				parent.removeChild(this);
			
			if (bitmapData)
				bitmapData.dispose();
			
			removeEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler);
		}
		
	}
}