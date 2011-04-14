package ghostcat.fileformat.swf
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import ghostcat.fileformat.swf.tag.SymbolClassTag;
	
	[Event("complete",type="flash.events.Event")]
	
	public class SWFFile extends EventDispatcher
	{
		public var decoder:SWFDecoder;
		public var classNames:Array;
		public var swf:Loader;
		public var classes:Object;
		
		public function SWFFile(data:ByteArray = null)
		{
			if (data)	
				read(data);
		}
		
		public function read(data:ByteArray):void
		{		
			this.swf = new Loader();
			this.swf.contentLoaderInfo.addEventListener(Event.COMPLETE,swfCompleteHandler);
			this.swf.loadBytes(data,new LoaderContext(false,ApplicationDomain.currentDomain))
			this.decoder = new SWFDecoder(data);
			this.classNames = decoder.getTags(SymbolClassTag)[0].symbolClasses;
		}
		
		private function swfCompleteHandler(event:Event):void
		{
			this.swf.contentLoaderInfo.removeEventListener(Event.COMPLETE,swfCompleteHandler);
			this.classes = {};
			for each(var p:String in classNames)
			{
				this.classes[p] = getDefinition(p);
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function getDefinition(name:String):Class
		{
			try
			{
				var ref:Class = swf.contentLoaderInfo.applicationDomain.getDefinition(name) as Class;
			}
			catch (e:ReferenceError){}
			return ref;
		}
	}
}