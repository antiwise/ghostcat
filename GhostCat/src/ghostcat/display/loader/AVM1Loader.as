package ghostcat.display.loader
{
	import flash.display.AVM1Movie;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.setTimeout;
	
	[Event(name="init",type="flash.events.Event")]
	[Event(name="open",type="flash.events.Event")]
	[Event(name="complete",type="flash.events.Event")]
	[Event(name="progress",type="flash.events.ProgressEvent")]
	[Event(name="data",type="flash.events.DataEvent")]
	
	/**
	 * 加载并操作AVM1的MovieClip
	 * @author flashyiyi
	 * 
	 */
	public class AVM1Loader extends Sprite
	{
		[Embed(source = "../asset/avm1link.swf",mimeType="application/octet-stream")]
		private var linkMovieRef:Class;
		private var loader:Loader;
		private var lc:LocalConnection = new LocalConnection();
		
		public var linkContent:AVM1Movie;
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
			linkContent = loader.content as AVM1Movie;
		}
		
		public function load(url:String):void
		{
			if (!linkContent)
			{
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completeHandler);
				return;
			}
			
			lc.send("AVM1Link","load",url);
			
			function completeHandler(event:Event):void
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,completeHandler);
				linkContent = loader.content as AVM1Movie;
				load(url);
			}
		}
		
		public function getValue(target:String):void
		{
			lc.send("AVM1Link","getValue",target);
		}
		
		public function setValue(target:String,v:Object):void
		{
			lc.send("AVM1Link","setValue",target,v);
		}
		
		public function call(target:String,param:Object = null):void
		{
			lc.send("AVM1Link","call",target,param);
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
	}
}