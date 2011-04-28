package ghostcattools.util
{
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import spark.components.mediaClasses.VolumeBar;

	public class Config
	{
		[Bindable]
		static public var NOTEPAD_PATH:String = "C:\\WINDOWS\\NOTEPAD.EXE";
		
		[Bindable]
		static public var FLEXSDK_PATH:String = "";
		
		[Bindable]
		static public var EXPLORER_PATH:String = "C:\\WINDOWS\\EXPLORER.EXE"
		
		static public const ASDOC:String = "bin/asdoc.exe";
		static public const MXMLC:String = "bin/mxmlc.exe";
		
		static public function get MXMLC_PATH():String
		{
			return Config.FLEXSDK_PATH + "\\" + Config.MXMLC;
		}
		
		static public function save():void
		{
			var xml:XML = <GhostCatTools/>;
			xml.config.NOTEPAD_PATH = NOTEPAD_PATH;
			xml.config.FLEXSDK_PATH = FLEXSDK_PATH;
			xml.config.EXPLORER_PATH = EXPLORER_PATH;
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(xml.toXMLString());
			
			var file:File = File.applicationStorageDirectory.resolvePath("config.xml");
			FileControl.writeFile(file,bytes);
		}
		
		static public function load():void
		{
			var file:File = File.applicationStorageDirectory.resolvePath("config.xml");
			if (file.exists)
			{
				var bytes:ByteArray = FileControl.readFile(file);
				var xml:XML = new XML(bytes.toString())
					
				NOTEPAD_PATH = xml.config.NOTEPAD_PATH;
				FLEXSDK_PATH = xml.config.FLEXSDK_PATH;
				EXPLORER_PATH = xml.config.EXPLORER_PATH;
			}
		}
	}
}