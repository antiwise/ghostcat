package ghostcat.fileformat.swf
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.IDataInput;
	
	import ghostcat.fileformat.zip.ZipFile;
	
	[Event("complete",type="flash.events.Event")]
	
	public class SWCFile extends EventDispatcher
	{
		public var zip:ZipFile;
		public var catalog:XML;
		public var swf:Loader;
		public var classes:Object;
		
		public function SWCFile(data:IDataInput = null)
		{
			if (data)	
				read(data);
		}
		
		public function read(data:IDataInput):void
		{		
			this.zip = new ZipFile(data);
			this.catalog = new XML(zip.getInput(zip.getEntry("catalog.xml")).toString());
			this.swf = new Loader();
			this.swf.contentLoaderInfo.addEventListener(Event.COMPLETE,swfCompleteHandler);
			this.swf.loadBytes(zip.getInput(zip.getEntry("library.swf")),new LoaderContext(false,ApplicationDomain.currentDomain))
		}
		
		private function swfCompleteHandler(event:Event):void
		{
			this.swf.contentLoaderInfo.removeEventListener(Event.COMPLETE,swfCompleteHandler);
			var space:Namespace = this.catalog.namespace();
			var types:* = this.catalog.space::libraries.space::library.space::script
			this.classes = {};
			for each(var p:XML in types)
			{
				var key:String = p.@name.toString();
				key = key.replace(/\//g,".");
				this.classes[key] = getDefinition(key);
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