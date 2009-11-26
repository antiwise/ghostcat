package ghostcat.display.loader
{
	import flash.display.AVM1Movie;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	[Event(name="init",type="flash.events.Event")]
	[Event(name="open",type="flash.events.Event")]
	[Event(name="complete",type="flash.events.Event")]
	[Event(name="progress",type="flash.events.ProgressEvent")]
	[Event(name="data",type="flash.events.DataEvent")]
	
	/**
	 * 加载并操作AVM1Movie的MovieClip，它可以直接和AS2的SWF通信
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class AVM1Loader extends Sprite
	{
		[Embed(source = "avm1link.swf",mimeType="application/octet-stream")]
		private var linkMovieRef:Class;
		private var loader:Loader;
		private var lc:LocalConnection = new LocalConnection();
		
		public var content:AVM1Movie;
		public var lastResult:Object;
		public var bytesLoaded:uint;
		public var bytesTotal:uint;
		
		public function AVM1Loader()
		{
			lc.connect("AVM2Link");
			lc.client = {
				onLoadInit : onLoadInit,
				onLoadProgress : onLoadProgress,
				onLoadError : onLoadError,
				onLoadComplete : onLoadComplete,
				onLoadStart : onLoadStart,
				getValueCallback : getValueCallback
			};
			lc.addEventListener(StatusEvent.STATUS,statusHandler);
			
			loader = new Loader();
			addChild(loader);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,initCompleteHandler);
			loader.loadBytes(new linkMovieRef(),new LoaderContext(false,ApplicationDomain.currentDomain));
		}
		
		private function statusHandler(event:StatusEvent):void
		{
		}
		
		private function initCompleteHandler(event:Event):void
		{
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,initCompleteHandler);
			content = loader.content as AVM1Movie;
		}
		
		/**
		 * 载入影片
		 * @param url
		 * 
		 */
		public function load(url:String):void
		{
			if (!content)
			{
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completeHandler);
				return;
			}
			
			lc.send("AVM1Link","load",url);
			
			function completeHandler(event:Event):void
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,completeHandler);
				content = loader.content as AVM1Movie;
				load(url);
			}
		}
		
		/**
		 * 获得属性，返回值会通过DataEvent返回
		 * @param target
		 * 
		 */
		public function getValue(target:String,rHandler:Function):void
		{
			lc.send("AVM1Link","getValue",target);
			if (rHandler != null)
				addEventListener(DataEvent.DATA,dataHandler);
			
			function dataHandler(event:DataEvent):void
			{
				removeEventListener(DataEvent.DATA,dataHandler);
				rHandler(event.data);
			}
		}
		
		/**
		 * 设置属性
		 * @param target
		 * @param v
		 * 
		 */
		public function setValue(target:String,v:Object):void
		{
			lc.send("AVM1Link","setValue",target,v);
		}
		
		/**
		 * 调用方法
		 * @param target	方法路径
		 * @param param	方法参数
		 * 
		 */
		public function call(target:String,params:Array = null,rHandler:Function=null):void
		{
			lc.send("AVM1Link","call",target,params);
			if (rHandler != null)
				addEventListener(DataEvent.DATA,dataHandler);
			
			function dataHandler(event:DataEvent):void
			{
				removeEventListener(DataEvent.DATA,dataHandler);
				rHandler(event.data);
			}
		}
		
		protected function onLoadInit():void
		{
			dispatchEvent(new Event(Event.INIT));
		}
		
		protected function onLoadProgress(bytesLoaded:uint,bytesTotal:uint):void
		{
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,bytesLoaded,bytesTotal))
			this.bytesLoaded = bytesLoaded;
			this.bytesTotal = bytesTotal;
		}
		
		protected function onLoadError():void
		{
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}
		
		protected function onLoadComplete():void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function onLoadStart():void
		{
			dispatchEvent(new Event(Event.OPEN));
		}
		
		protected function getValueCallback(v:Object):void
		{
			lastResult = v;
			dispatchEvent(new DataEvent(DataEvent.DATA,false,false,String(v)));
		}
		
		/**
		 * 停止动画
		 * 
		 */
		public function stop():void
		{
			call("stop");
		}
		
		/**
		 * 跳转并播放 
		 * @param frame
		 * 
		 */
		public function gotoAndPlay(frame:int):void
		{
			call("gotoAndPlay",[frame]);
		}
		
		/**
		 * 跳转并停止 
		 * @param frame
		 * 
		 */
		public function gotoAndStop(frame:int):void
		{
			call("gotoAndStop",[frame]);
		}
	}
}