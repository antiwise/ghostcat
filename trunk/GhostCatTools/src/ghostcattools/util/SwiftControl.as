package ghostcattools.util
{
	import avmplus.getQualifiedClassName;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	
	import ghostcat.util.code.CodeCreater;
	
	import ghostcattools.tools.vo.EmbedVO;
	
	import mx.core.BitmapAsset;
	import mx.core.ByteArrayAsset;
	import mx.core.MovieClipAsset;
	import mx.core.MovieClipLoaderAsset;
	import mx.core.SoundAsset;
	import mx.core.SpriteAsset;

	public final class SwiftControl
	{
		static public const swf:Array = ["swf","svg"];
		static public const mp3:Array = ["mp3","aac","m4a","mp4"];
		static public const jpg:Array = ["jpg"];
		static public const png:Array = ["png","gif"];
		static public const all:Array = swf.concat(mp3).concat(jpg).concat(png);
		static public function createXMLNode(v:EmbedVO):XML
		{
			var type:String = v.type;
			var result:XML;
			if (swf.indexOf(type) != -1)
			{
				//
			}
			else if (mp3.indexOf(type) != -1)
			{
				result = <sound/>
			}
			else if (png.concat(jpg).indexOf(type) != -1)
			{
				result = <bitmap/>
				if (v.compression && v.quality)
				{
					result.@compression = true;
					result.@quality = v.quality;
				}
			}
			else
			{
				result = <bytearray/>
			}
			
			if (result)
			{
				result.@file = v.source;
				result["@class"] = v.className;
			}
			return result;
		}
		
		static public function createXMLFile(list:Array):XML
		{
			var xml:XML = <lib/>
			for each (var v:EmbedVO in list)
			{
				var path:String = v.className;
				if (path)
				{
					var node:XML = createXMLNode(v);
					if (node)
						xml.appendChild(node);
				}
			}
			return xml;
		}
		
		static public function createSWC(file:File,list:Array,completeHandler:Function = null,traceHandler:Function = null,errorHandler:Function = null,sendResultBytes:Boolean = true):void
		{
			var xml:XML = createXMLFile(list);
			
			var asFile:File = File.createTempFile();
			asFile = asFile.parent.resolvePath(asFile.name.slice(0,asFile.name.length - 4) + ".xml");
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(xml.toXMLString());
			FileControl.writeFile(asFile,bytes);
			
			var compc:File = new File(Config.JAVA_PATH);
			if (!compc.exists)
				return;
			
			var params:Array = ["-jar",File.applicationDirectory.resolvePath("Swift.jar").nativePath,"xml2lib",asFile.nativePath,file.nativePath];
				
			FileControl.run(compc,params,exitHandler,traceHandler,errorHandler);
			function exitHandler(event:Event):void
			{
				var swfBytes:ByteArray = file.exists ? (sendResultBytes ? FileControl.readFile(file) : new ByteArray()) : null;
				if (completeHandler != null)
					completeHandler(swfBytes);
				
				asFile.deleteFileAsync();
			}
		}
	}
}