package ghostcat.util.load
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
	
	/**
	 * 组合载入辅助类
	 * @author flashyiyi
	 * 
	 */
	public class GroupLoaderHelper extends EventDispatcher
	{
		private var startTime:int;
		private var _bytesTotal:int = -1;
		private var completeCount:int;
		
		/**
		 * 加载器列表
		 */
		public var loaders:Array;
		
		public function GroupLoaderHelper(loaders:Array = null):void
		{
			this.completeCount = 0;
			this.startTime = getTimer();
			
			if (loaders)
			{
				for (var i:int = 0;i < loaders.length;i++)
					addLoader(loaders[i]);
			}
		}
		
		public function addLoader(v:EventDispatcher):void
		{
			if (!loaders)
				loaders = [];
			
			var loadInfo:EventDispatcher;
			
			if (v is Loader)
				loadInfo = (v as Loader).contentLoaderInfo;
			else
				loadInfo = v;
			
			loadInfo.addEventListener(ProgressEvent.PROGRESS,progressHandler);
			loadInfo.addEventListener(Event.COMPLETE,completeHandler);
			loadInfo.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			
			loaders.push(loadInfo);
		}
		
		/**
		 * 已加载的字节数
		 * 
		 * @return 
		 * 
		 */
		public function get bytesLoaded():int
		{
			var v:int = 0;
			for each (var loadInfo:EventDispatcher in loaders)
				v += loadInfo["bytesLoaded"];
			
			return v;
		}
		
		/**
		 * 总字节数
		 * 
		 * @return 
		 * 
		 */
		public function get bytesTotal():int
		{
			if (_bytesTotal != -1)
				return _bytesTotal;
			
			var v:int = 0;
			for each (var loadInfo:EventDispatcher in loaders)
			{
				v += loadInfo["bytesTotal"];
			}
			
			return v;
		}
		
		public function set bytesTotal(v:int):void
		{
			_bytesTotal = v;
		}
		
		/**
		 * 加载进度
		 * 
		 * @return 
		 * 
		 */
		public function get loadPercent():Number
		{
			return (bytesTotal == 0) ? 0 : (bytesLoaded / bytesTotal);
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
		
		private function progressHandler(event:ProgressEvent):void
		{
			var e:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS,false,false,bytesLoaded,bytesTotal);
			this.dispatchEvent(e);
		}
		
		private function completeHandler(event:Event):void
		{
			removeEvents(event.currentTarget as EventDispatcher);
			this.completeCount++;
			if (this.completeCount == this.loaders.length)
				this.dispatchEvent(event);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			removeEvents(event.currentTarget as EventDispatcher);
			this.dispatchEvent(event);
		}
		
		private function removeEvents(loadInfo:EventDispatcher):void
		{
			loadInfo.removeEventListener(ProgressEvent.PROGRESS,progressHandler);
			loadInfo.removeEventListener(Event.COMPLETE,completeHandler);
			loadInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
		}
		
		public function destory():void
		{
			if (this.loaders)
			{
				for each (var loader:EventDispatcher in loaders)
					removeEvents(loader);
			}
		}
	}
}