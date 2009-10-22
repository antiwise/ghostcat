package panel
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import mx.managers.CursorManager;
	
	public class CheckSWFPanelBase extends PanelBase
	{
		import mx.collections.ArrayCollection;
		import mx.events.ListEvent;
		import flash.filesystem.File;
		import mx.controls.Image;
		
		[Bindable]
		public var pathList:ArrayCollection;
		
		override protected function doWithSource(v:File) : void
		{
			pathList = new ArrayCollection();
			if (v.isDirectory)
			{
				fillList(v);
			}
			else
			{
				var url:String = v.nativePath;
				if (url.substr(url.length - 4)==".swf")
					check(url);
			}
		}
		
		private function fillList(v:File):void
		{
			if (v.isDirectory)
			{
				var list:Array = v.getDirectoryListing();
				for (var i:int = 0; i < list.length; i++)
				{
					var file:File = list[i] as File;
					if (file.isDirectory)
					{
						fillList(file);
					}
					else
					{
						var url:String = file.nativePath;
						if (url.substr(url.length - 4)==".swf")
						{
							check(url);
						}
					}
				}
			}
		}
		
		private function check(url:String):void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadCompleteHandler);
			loader.load(new URLRequest(url));
		
			CursorManager.setBusyCursor();
		}
		
		private function loadCompleteHandler(event:Event):void
		{
			CursorManager.removeBusyCursor();
			
			(event.currentTarget as LoaderInfo).removeEventListener(Event.COMPLETE,loadCompleteHandler);
			checkHandler((event.currentTarget as LoaderInfo).loader);
		}
		
		protected function checkHandler(loader:Loader):void
		{
			loader.unload();
		}
		
		public function getList():String
		{
			var result:String = "";
			for (var i:int = 0;i < pathList.length;i++)
			{
				result += pathList.getItemAt(i) + "\r\n";
			}
			return result;
		}
	}
}