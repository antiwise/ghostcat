package ghostcat.fileformat.swf
{
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import ghostcat.debug.Debug;
	import ghostcat.fileformat.swf.tag.Tag;
	import ghostcat.util.data.BitUtil;
	import ghostcat.util.data.ByteArrayReader;

	/**
	 * SWF文件解析器
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class SWFDecoder
	{
		private var bytes:ByteArray;
		
		private var tagList:Array;
		
		/**
		 * 是否压缩
		 */
		public var compressed:Boolean;
		
		/**
		 * 版本号
		 */		
		public var verison:int;
		
		/**
		 * 文件大小（解压后）
		 */		
		public var fileLength:uint;
		
		/**
		 * 舞台范围
		 */		
		public var frameSize:Rectangle;
		
		/**
		 * 帧频
		 */
		public var frameRate:Number;
		
		/**
		 * 总帧数
		 */
		public var frameCount:int;
		
		//文件头长度（指的是未压缩部分的长度）
		private var headLength:uint;
		
		public function SWFDecoder(data:ByteArray = null)
		{
			if (data)
				read(data);
		}
		
		/**
		 * 读取
		 * 
		 * @param data
		 * 
		 */
		public function read(data:ByteArray,readTag:Boolean = true):void
		{
			this.bytes = new ByteArray();
			this.bytes.endian = Endian.LITTLE_ENDIAN;
			this.bytes.writeBytes(data);
			this.bytes.position = 0;
			
			readHead();	
			if (readTag)
				readTagList();
		}
		
		/**
		 * 获得Tag列表
		 * 
		 * @return 
		 * 
		 */
		public function getAllTags():Array
		{
			return tagList;
		}
		
		/**
		 * 获得某个类型的全部Tag
		 * 
		 * @param tagClass	Tag的类型
		 * @return 
		 * 
		 */
		public function getTags(tagClass:Class):Array
		{
			var simpTag:Tag = new tagClass();
			var type:int = simpTag.type;
			if (type == 0)
				Debug.error("继承Tag的类必须重写自己的type存取器")
				
			var result:Array = [];
			for (var i:int = 0;i < tagList.length;i++)
			{
				var tagItem:TagItem = tagList[i] as TagItem;
				if (tagItem.type == type)
				{
					var newTag:Tag = new tagClass();
					newTag.bytes = this.bytes;
					newTag.position = tagItem.position;
					newTag.bytes.position = newTag.position - headLength;
					newTag.length = tagItem.length;
					
					var header:uint = newTag.bytes.readUnsignedShort();
					newTag.length = BitUtil.getShiftedValue2(header,16,10,16);
					if (newTag.length == 0x3F)
						newTag.length = newTag.bytes.readInt();
						
					newTag.read();
					
					result.push(newTag);
				}
			}
			
			return result;
		}
		
		private function readHead():void
		{
			var typeValue:String = bytes.readUTFBytes(3);
			
			if (typeValue == "FWS")
				compressed = false;
			else if (typeValue == "CWS")
				compressed = true;
			else
				throw new Error("这个文件不是合法的SWF文件");
				
			verison = bytes.readUnsignedByte();
			fileLength = bytes.readUnsignedInt();
			
			this.headLength = bytes.position;
			
			bytes.readBytes(bytes);
			bytes.position = 0;
			
			if (compressed)
				bytes.uncompress();
			
			frameSize = readRect(bytes);
			frameRate  = Number(bytes.readUnsignedShort() / 256);
			frameCount = bytes.readUnsignedShort();
		}
		
		private function readTagList():void
		{
			tagList = [];
			while (bytes.bytesAvailable)
			{
				var tag:TagItem = new TagItem();
				tag.position = bytes.position + headLength;
				
				var header:uint = bytes.readUnsignedShort();
				tag.type = BitUtil.getShiftedValue2(header,16,0,10);
				tag.length = BitUtil.getShiftedValue2(header,16,10,16);
				if (tag.length == 0x3F)
					tag.length = bytes.readInt();
				tagList.push(tag);
				
				bytes.position += tag.length;
			}
		}
		
		/**
		 * 读取RECT
		 *  
		 * @param bytes
		 * @return 
		 * 
		 */
		public static function readRect(bytes:ByteArray):Rectangle
		{
			var byteArrayReader:ByteArrayReader = new ByteArrayReader(bytes);
			var t:int = byteArrayReader.readBits(5);
			var wmin:int = byteArrayReader.readBits(t) / 20;
			var wmax:int = byteArrayReader.readBits(t) / 20;
			var hmin:int = byteArrayReader.readBits(t) / 20;
			var hmax:int = byteArrayReader.readBits(t) / 20;
			return new Rectangle(wmin,hmin,wmax - wmin,hmax - hmin);
		}	
		
		/**
		 * 读取一个以0结尾的字符串
		 * 
		 * @param length	长度，默认则以取到0为止或者文件尾
		 * @return 
		 * 
		 */
		public static function readString(bytes:ByteArray,length:int = 0):String
		{
			var text:String = "";
			
			try
			{
				if (length > 0)
					text = bytes.readUTFBytes(length);
				else
				{
					var v:int = bytes.readUnsignedByte();
					while (v)
					{
						text += String.fromCharCode(v);
						v = bytes.readUnsignedByte();
					}
				}
			}
			catch (e:Error)
			{};
			
			return text;
		}
		
		public static function readDate(bytes:ByteArray):Date
		{
			var low:uint = bytes.readUnsignedInt();
			var high:uint = bytes.readUnsignedInt();
			return new Date(high * 0x100000000 + low)
		}
	}
}

class TagItem
{
	/**
	 * 数据类型 
	 */
	public var type:int;
	/**
	 * 在数据中的起点位置
	 */
	public var position:int;
	/**
	 * 数据长度
	 */
	public var length:int;
}