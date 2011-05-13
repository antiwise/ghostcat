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

	public final class EmbedControl
	{
		static public const swf:Array = ["swf","svg"];
		static public const mp3:Array = ["mp3","aac","m4a","mp4"];
		static public const jpg:Array = ["jpg"];
		static public const png:Array = ["png","gif"];
		static public const all:Array = swf.concat(mp3).concat(jpg).concat(png);
		static public function createEmbedString(v:EmbedVO):String
		{
			var type:String = v.type;
			var result:Array = [];
			
			result.push("source=\"" + v.source.replace(/\\/g,"\\\\") +"\"");
			
			if (v.symbol && swf.indexOf(type) != -1)
			{
				result.push("symbol=\"" + v.symbol +"\"")
			}
			
			if (v.compression && v.quality && png.concat(jpg).indexOf(type) != -1 && Config.FLEXSDK_4_0)
			{
				result.push("compression=\"" + v.compression +"\"")
				result.push("quality=\"" + v.quality +"\"")
			}
			
			if (v.scaleGrid && (swf.indexOf(type) != -1 || jpg.indexOf(type) != -1))
			{
				var scaleGridArr:Array = String(v.scaleGrid).split(",");
				if (scaleGridArr.length >= 4)
				{
					result.push("scaleGridLeft=\"" + Number(scaleGridArr[0]) +"\"");
					result.push("scaleGridTop=\"" + Number(scaleGridArr[1]) +"\"");
					result.push("scaleGridRight=\"" + Number(scaleGridArr[2]) +"\"");
					result.push("scaleGridBottom=\"" + Number(scaleGridArr[3]) +"\"");
				}
			}
			if (all.indexOf(v.type) == -1)
			{
				result.push("mimeType=\"application/octet-stream\"");
			}
			return "[Embed(" + result.join(",") + ")]";
		}
		
		static public function createASFile(v:EmbedVO):String
		{
			var classPath:String = v.className;
			var names:Array = classPath.split(".");
			var name:String = names.pop();
			var pack:String = names.join(".");
			var extendClass:Class;
			if (jpg.indexOf(v.type) != -1)
			{
				extendClass = v.scaleGrid ? SpriteAsset: BitmapAsset;
			}
			else if (png.indexOf(v.type) != -1)
			{
				extendClass = BitmapAsset;
			}
			else if (mp3.indexOf(v.type) != -1)
			{
				extendClass = SoundAsset
			}
			else if (swf.indexOf(v.type) != -1)
			{
				extendClass = MovieClipAsset;
			}
			else
			{
				extendClass = ByteArrayAsset;
			}
			
			var extend:String = getQualifiedClassName(extendClass).replace("::",".");
			return "package " + pack + "{import "+ extend +"\r\n" + createEmbedString(v) + "public class " + name + " extends " + extend + "{}}";
		}
		
		static public function createSWC(file:File,list:Array,completeHandler:Function = null,traceHandler:Function = null,errorHandler:Function = null,sendResultBytes:Boolean = true):void
		{
			var src:File = File.createTempDirectory();
			src.createDirectory();
			for each (var v:EmbedVO in list)
			{
				var path:String = v.className;
				if (path)
				{
					path = path.replace(/\./,"\\") + ".as";
					var asFile:File = src.resolvePath(path);
					var asText:String = createASFile(v);
					var bytes:ByteArray = new ByteArray();
					bytes.writeUTFBytes(asText);
					FileControl.writeFile(asFile,bytes);
				}
			}
			var compc:File = new File(Config.FLEXSDK_PATH + "\\" + Config.COMPC);
			if (!compc.exists)
				return;
			
			var params:Array = ["-source-path="+src.nativePath,"-output="+file.nativePath,"-include-sources="+src.nativePath];
				
			FileControl.run(compc,params,exitHandler,traceHandler,errorHandler);
			function exitHandler(event:Event):void
			{
				var swfBytes:ByteArray = file.exists ? (sendResultBytes ? FileControl.readFile(file) : new ByteArray()) : null;
				if (completeHandler != null)
					completeHandler(swfBytes);
				
				src.deleteDirectory(true);
			}
		}
	}
}