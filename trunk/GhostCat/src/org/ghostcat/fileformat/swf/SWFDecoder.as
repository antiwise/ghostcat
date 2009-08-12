package org.ghostcat.fileformat.swf
{
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import org.ghostcat.fileformat.swf.tag.Tag;
	import org.ghostcat.util.BitUtil;
	import org.ghostcat.util.ByteArrayReader;

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
		public var frameRate:int;
		
		/**
		 * 总帧数
		 */
		public var frameCount:int;
		
		public function read(data:ByteArray):void
		{
			this.bytes = data;
			this.bytes.endian = Endian.LITTLE_ENDIAN;
			
			readHead();	
			readTagList();
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
			var type:int = tagClass["type"];
			var result:Array = [];
			for (var i:int = 0;i < tagList.length;i++)
			{
				var tagItem:TagItem = tagList[i] as TagItem;
				if (tagItem.type == type)
				{
					var newTag:Tag = new tagClass();
					newTag.bytes = this.bytes;
					newTag.position = tagItem.position;
					newTag.length = tagItem.length;
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
			
			var newBytes:ByteArray = new ByteArray();
			newBytes.readBytes(bytes);
			bytes = newBytes;
			
			if (compressed)
				bytes.uncompress();
			
			frameSize = readRect();
			frameRate  = int(bytes.readUnsignedShort() / 256);
			frameCount = bytes.readUnsignedShort();
		}
		
		private function readTagList():void
		{
			tagList = [];
			while (bytes.bytesAvailable)
			{
				var tag:TagItem = new TagItem();
				var header:uint = bytes.readUnsignedShort();
				tag.type = BitUtil.getShiftedValue2(header,16,0,10);
				tag.length = BitUtil.getShiftedValue2(header,16,10,16);
				if (tag.length == 0x3F)
					tag.length = bytes.readInt();
				tag.position = bytes.position;
				
				tagList.push(tag);
				
				bytes.position += tag.length;
			}
		}
		
		private function readRect():Rectangle
		{
			var byteArrayReader:ByteArrayReader = new ByteArrayReader(bytes);
			var t:int = byteArrayReader.readBits(5);
			var wmin:int = byteArrayReader.readBits(t) / 20;
			var wmax:int = byteArrayReader.readBits(t) / 20;
			var hmin:int = byteArrayReader.readBits(t) / 20;
			var hmax:int = byteArrayReader.readBits(t) / 20;
			return new Rectangle(wmin,hmin,wmax - wmin,hmax - hmin);
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
	 * 在数据源中的起点位置
	 */
	public var position:int;
	/**
	 * 数据长度
	 */
	public var length:int;
}