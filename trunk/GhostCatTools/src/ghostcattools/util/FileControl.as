package ghostcattools.util
{
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.NativeDragEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	public final class FileControl
	{
		static public function dragFileIn(rHandler:Function,target:InteractiveObject,extension:Array = null):void
		{
			target.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,onDragIn);		
			target.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,onDrop);
			
			function onDragIn(event:NativeDragEvent):void
			{
				var transferable:Clipboard = event.clipboard;
				if (transferable.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
				{
					var files:Array = transferable.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
					if (files)
					{
						if (!extension || extension.length == 0 || extension.indexOf(File(files[0]).nativePath.split(".")[1].toLowerCase()) != -1)
							NativeDragManager.acceptDragDrop(target);
					}
				}
			}
			
			function onDrop(event:NativeDragEvent):void
			{
				rHandler(event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT));
			}
		}
		
		static public function browseForOpen(rHandler:Function,title:String,extension:Array = null):void
		{
			var file:File = File.documentsDirectory;
			file.browseForOpen(title,extension);
			if (rHandler != null)
				file.addEventListener(Event.SELECT,selectHandler);
			
			function selectHandler(event:Event):void
			{
				rHandler([file]);
			}
		}
		
		static public function browseForSave(rHandler:Function,title:String,path:String = null):void
		{
			var file:File = File.documentsDirectory.resolvePath(path);
			file.browseForSave(title);
			if (rHandler != null)
				file.addEventListener(Event.SELECT,selectHandler);
			
			function selectHandler(event:Event):void
			{
				rHandler([file]);
			}
		}
		
		static public function readFile(file:File):ByteArray
		{
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.READ);
			var bytes:ByteArray = new ByteArray();
			fs.readBytes(bytes);
			fs.close();
			return bytes;
		}
		
		
		static public function writeFile(file:File,bytes:ByteArray):void
		{
			bytes.position = 0;
			
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			fs.writeBytes(bytes);
			fs.close();
		}
		
		static public function createLoadContext():LoaderContext
		{
			var context:LoaderContext = new LoaderContext();
			context.allowCodeImport = true;
			return context;
		}
		
		static public function run(url:String,arg:Array = null,exitHandler:Function = null):void
		{
			var file:File = File.documentsDirectory.resolvePath(url);
			
			var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			nativeProcessStartupInfo.executable = file;
			if (arg)
			{
				var arguments:Vector.<String> = new Vector.<String>();
				arguments.push.apply(null,arg);
				nativeProcessStartupInfo.arguments = arguments;
			}
			
			var process:NativeProcess = new NativeProcess();
			if (exitHandler != null)
				process.addEventListener(NativeProcessExitEvent.EXIT,exitHandler);
			process.start(nativeProcessStartupInfo);
		}
	}
}