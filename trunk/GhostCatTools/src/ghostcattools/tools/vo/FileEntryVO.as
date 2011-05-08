package ghostcattools.tools.vo
{
	import flash.utils.ByteArray;
	
	import ghostcat.fileformat.zip.CRC32;
	import ghostcat.fileformat.zip.ZipEntry;
	import ghostcat.fileformat.zip.ZipFile;

	public class FileEntryVO
	{
		[Bindable]
		public var name:String;
		[Bindable]
		public var size:int;
		[Bindable]
		public var compressedSize:int;
		[Bindable]
		public var time:Number;
		[Bindable]
		public var method:int = -1;
		[Bindable]
		public var comment:String;
		public var crc:uint;
		public var isNew:Boolean;
		private var _bytes:ByteArray;
		
		
		private var zipFile:ZipFile;
		private var zipEntry:ZipEntry;
		
		public function get bytes():ByteArray
		{
			if (zipEntry)
			{
				_bytes = size ? zipFile.getInput(zipEntry) : new ByteArray();
				zipFile = null;
				zipEntry = null;
			}
			return _bytes;
		}

		public function set bytes(value:ByteArray):void
		{
			_bytes = value;
			zipFile = null;
			zipEntry = null;
		}

		public function get localName():String
		{
			var paths:Array = name.split("/");
			return isDirectory() ? paths[paths.length - 2] : paths[paths.length - 1];
		}
		
		public function get compressedPerent():Number
		{
			return size ? compressedSize / size: 0;
		}
		
		public function FileEntryVO(name:String = null):void
		{
			this.name = name;
		}
		
		public function isChild(parent:FileEntryVO):Boolean
		{
			return this.name != parent.name && this.name.slice(0,parent.name.length) == parent.name;
		}
		
		public function importFromZipEntry(source:ZipEntry,zipFile:ZipFile):void
		{
			this.name = source.name;
			
			if (!source.isDirectory())
			{
				this.size = source.size;
				this.compressedSize = source.compressedSize;
				this.time = source.time;
				this.method = source.method;
				this.crc = source.crc;
				this.comment = source.comment;
			
				this.zipEntry = source;
				this.zipFile = zipFile;
			}
		}
		
		public function createData(bytes:ByteArray):void
		{
			this.bytes = bytes;
			this.size = bytes.length;
			this.time = new Date().getTime();
			
			var crc32:CRC32 = new CRC32()
			crc32.update(bytes);
			this.crc = crc32.getValue();
			
			this.isNew = true;
		}
		
		public function isDirectory():Boolean
		{
			return name.charAt(name.length - 1) == '/';
		}
		
		public function isBackDirectory():Boolean
		{
			return name.slice(name.length - 4) == '/../';
		}
		
		public function createZipEntry():ZipEntry
		{
			var zipEntry:ZipEntry = new ZipEntry(this.name);
			if (this.method == 0)
			{
				zipEntry.size = this.size;
				zipEntry.time = this.time;
				zipEntry.crc = this.crc;
			}
			zipEntry.method = this.method;
			zipEntry.comment = this.comment;
			return zipEntry;
		}
	}
}