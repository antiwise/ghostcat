package ghostcat.other
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	import ghostcat.events.OperationEvent;
	import ghostcat.operation.FileLoadOper;
	
	/**
	 * 此类可Dump SWF打包方式
	 * @author flashyiyi
	 * 
	 */
	public class SWFDump extends Sprite
	{
		private var file:FileReference;
		private var loader:Loader;
		
		/**
		 * 查询子SWF内元件的方法 
		 */
		public var dumpFunction:Function;
		
		public function SWFDump(dumpFunction:Function = null) 
		{
			if (dumpFunction == null)
				this.dumpFunction = defaultDumpFunction;
			
			file = new FileReference();
			file.addEventListener(Event.SELECT,selectFileHandler);
			file.browse();
		}
		
		private function selectFileHandler(event:Event):void
		{
			file.removeEventListener(Event.COMPLETE,selectFileHandler);
			file.addEventListener(Event.COMPLETE,loadCompleteHandler);
			file.load();
		}
		
		private function loadCompleteHandler(event:Event):void
		{
			loader = new Loader();
			addChild(loader);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,swfCompleteHandler);
			loader.loadBytes(file.data);
		}
		
		private function swfCompleteHandler(event:Event):void
		{
			setTimeout(dumpHandler,1000);
		}
		
		private function dumpHandler():void
		{
			var sp:DisplayObject = dumpFunction(loader);
			if (sp)
				new FileReference().save(sp.loaderInfo.bytes);
		}
		
		private function defaultDumpFunction(sp:DisplayObject):DisplayObject
		{
			while (sp is DisplayObjectContainer)
				sp = (sp as DisplayObjectContainer).getChildAt(0);
			
			return sp;
		}
	}
}