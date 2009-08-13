/**
 * Copyright (C) 2007 Flashlizi (flashlizi@gmail.com, www.riaidea.com)
 *
 * ZipArchive是一个Zip档案处理类，可读写各种zip格式文件。
 * 功能：1)轻松创建或加载一个zip档案；2)多种方式读取和删除zip档案中的文件；3)支持中文文件名；
 * 4)非常容易序列化一个zip档案，如有AIR、PHP等的支持下就可以把生成的zip档案保存在本地或服务器上。
 *
 * 如有任何意见或建议，可联系我：MSN:flashlizi@hotmail.com
 *
 * @version 0.1
 */

package org.ghostcat.fileformat.zip{
	import flash.utils.ByteArray;
	
	/**
	 * CRC33校验类。
	 * @private
	 */
	public class CRC32 {
		
		/** The fast CRC table. Computed once when the CRC32 class is loaded. */
		private static var crcTable:Array = makeCrcTable();
		
		public function getCRC32(data:ByteArray, start:uint = 0, len:uint = 0):uint {
			if (start >= data.length) { start = data.length; }
			if (len == 0) { len = data.length - start; }
			if (len + start > data.length) { len = data.length - start; }
			var i:uint;
			var c:uint = 0xffffffff;
			for (i = start; i < len; i++) {
				c = uint(crcTable[(c ^ data[i]) & 0xff]) ^ (c >>> 8);
			}
			return (c ^ 0xffffffff);
		}
		/**
		 * 生成CRC表
		 * @return CRC表
		 */
		private static function makeCrcTable():Array {
			var crcTable:Array = [];
			for (var n:int = 0; n < 256; n++) {
				var c:uint = n;
				for (var k:int = 8; --k >= 0; ) {
					if((c & 1) != 0) c = 0xedb88320 ^ (c >>> 1);
					else c = c >>> 1;
				}
				crcTable[n] = c;
			}
			return crcTable;
		}
	}
}
