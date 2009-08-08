package org.ghostcat.display.loader
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.getTimer;
	
	[Event(name="complete",type="flash.events.Event")]
	[Event(name="io_error",type="flash.events.IOErrorEvent")]
	[Event(name="progress",type="flash.events.ProgressEvent")]
	
	public class LoadHelper extends EventDispatcher
	{
		/**
		 * 由事件获得
		 */
		public static const EVENT:int = 0;
		/**
		 * 由属性获得
		 */
		public static const PROPERTY:int = 1;
		
		private var loadInfo:EventDispatcher;
		private var startTime:int;
		private var _bytesLoaded:int;
		private var _bytesTotal:int;
		
		/**
		 * 此类用于计算载入进度相关数据
		 * 
		 */
		public function LoadHelper(dispatcher:EventDispatcher)
		{
			if (dispatcher is Loader)
				loadInfo = (dispatcher as Loader).contentLoaderInfo;
			else
				loadInfo = dispatcher;
		
			loadInfo.addEventListener(Event.OPEN,openHandler);
			loadInfo.addEventListener(ProgressEvent.PROGRESS,progressHandler);
			loadInfo.addEventListener(Event.COMPLETE,completeHandler);
			loadInfo.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			
			startTime = getTimer();
		}
		
		/**
		 * 检测模式：0 读取属性 1 由时间获得
		 */
		public var mode:int = 0;
		
		/**
		 * 已加载的字节数
		 * 
		 * @return 
		 * 
		 */
		public function get bytesLoaded():int
		{
			if (mode == EVENT)
				return _bytesLoaded;
			else
				return loadInfo["bytesLoaded"];
		}
		
		/**
		 * 总字节数
		 * 
		 * @return 
		 * 
		 */
		public function get bytesTotal():int
		{
			if (mode == EVENT)
				return _bytesTotal;
			else
				return loadInfo["bytesTotal"];
		}
		
		/**
		 * 加载进度
		 * 
		 * @return 
		 * 
		 */
		public function get loadPercent():Number
		{
			return bytesLoaded/bytesTotal;
		}
		
		/**
		 * 加载已经用的时间
		 * 
		 * @return 
		 * 
		 */		
		public function get progressTime():int
		{
			return getTimer() - startTime;
		}
		
		public function get progressTimeString():String
		{
			return timeToString(progressTime)
		}
		
		/**
		 * 预计还需要的时间
		 * 
		 * @return 
		 * 
		 */
		public function get progressNeedTime():int
		{
			return progressTime * (1 / loadPercent - 1);
		}
		
		public function get progressNeedTimeString():String
		{
			return timeToString(progressNeedTime)
		}
		
		private function timeToString(t:int):String
		{
			t /= 1000;
			var min:int = int(t / 60);
			var sec:int = t % 60;
			return (min>0)?(min.toString()+"分"):""+sec.toString()+"秒";
		}
		
		
		
		
		private function openHandler(event:Event):void
		{
			startTime = getTimer();
		}
		
		private function progressHandler(event:ProgressEvent):void
		{
			if (mode == EVENT)
			{
				_bytesLoaded = event.bytesLoaded;
				_bytesTotal = event.bytesTotal;
			}
			this.dispatchEvent(event);
		}
		
		private function completeHandler(event:Event):void
		{
			removeEvents();
			this.dispatchEvent(event);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			removeEvents();
			this.dispatchEvent(event);
		}
		
		private function removeEvents():void
		{
			loadInfo.removeEventListener(Event.OPEN,openHandler);
			loadInfo.removeEventListener(ProgressEvent.PROGRESS,progressHandler);
			loadInfo.removeEventListener(Event.COMPLETE,completeHandler);
			loadInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
		}
		
		public function destory():void
		{
			removeEvents();
		}
	}
}