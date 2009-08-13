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
	 * ZipFile类用于表示ZipArchive中的一个文件对象。
	 */
	public class ZipFile {
		
		/**
		 * @private
		 */
		internal var _name:String;
		/**
		 * @private
		 */
		internal var _data:ByteArray;
		/**
		 * @private
		 */
		internal var _version:uint;
		/**
		 * @private
		 */
		internal var _encrypted:Boolean = false;
		/**
		 * @private
		 */
		internal var _compressionMethod:int = -1;
		/**
		 * @private
		 */
		internal var _dostime:uint;
		/**
		 * @private
		 */
		internal var _crc32:uint;
		/**
		 * @private
		 */
		internal var _compressedSize:uint;
		/**
		 * @private
		 */
		internal var _size:uint;
		/**
		 * @private
		 */
		internal var _flag:uint;
		/**
		 * @private
		 */
		internal var _extra:ByteArray;
		/**
		 * @private
		 */
		internal var _comment:String;
		/**
		 * @private
		 */
		internal var _encoding:String = "";
		/**
		 * @private
		 */
		internal var _nameLength:uint;
		/**
		 * @private
		 */
		internal var _extraLength:uint;
		/**
		 * 构造函数，创建一个ZipFile对象。
		 * @param	name 文件名称
		 */
		public function ZipFile(name:String = null) {
			if (name)_name = name;
			_data = new ByteArray();
		}
		/**
		 * 获取文件名称。
		 */
		public function get name():String {
			return _name;
		}
		/**
		 * 获取zip压缩版本，默认为20，即2.0。
		 */
		public function get version():uint {
			return _version;
		}
		/**
		 * 获取文件原始大小。
		 */
		public function get size():uint {
			return _size;
		}
		/**
		 * 获取文件的压缩方法，可选值为0和8。
		 */
		public function get compressionMethod():int {
			return _compressionMethod;
		}
		/**
		 * 获取文件的CRC32校验码。
		 */
		public function get crc32():uint {
			return _crc32;
		}
		/**
		 * 获取文件压缩后的大小。
		 */
		public function get compressedSize():uint {
			return _compressedSize;
		}
		/**
		 * @private
		 */
		internal function get encrypted():Boolean {
			return _encrypted;
		}
		/**
		 * @private
		 */
		internal function get flag():uint {
			return _flag;
		}
		/**
		 * @private
		 */
		internal function get extra():ByteArray {
			return _extra ? _extra : null;
		}
		/**
		 * @private
		 */
		internal function get comment():String {
			return _comment ? _comment : null;
		}
		/**
		 * 设置和获取文件的原始二进制数据。
		 */
		public function get data():ByteArray {
			return _data;
		}
		public function set data(ba:ByteArray):void {
			_data = ba;
		}
		/**
		 * 设置和获取文件的创建时间。
		 */
		public function get date():Date {
			var sec:int = (_dostime & 0x1f) << 1;
			var min:int = (_dostime >> 5) & 0x3f;
			var hour:int = (_dostime >> 11) & 0x1f;
			var day:int = (_dostime >> 16) & 0x1f;
			var month:int = ((_dostime >> 21) & 0x0f) - 1;
			var year:int = ((_dostime >> 25) & 0x7f) + 1980;
			return new Date(year, month, day, hour, min, sec);
		}
		public function set date(date:Date):void {
			this._dostime =
						(date.fullYear - 1980 & 0x7f) << 25
						| (date.month + 1) << 21
						| date.date << 16
						| date.hours << 11
						| date.minutes << 5
						| date.seconds >> 1;
		}
		/**
		 * 覆盖默认的toString方法，其中包含ZipFile对象的主要属性。
		 * @return ZipFile对象的字符串表现形式。
		 */
		public function toString():String {
			var str:String = "[ZipFile Path=\"";
			str += _name + "\"]\rsize:" + _size + " compressedSize:" + compressedSize + " CRC32:" + crc32.toString(16).toLocaleUpperCase();
			str += "\rLast modify time:" + date + "\r";
			return str;
		}
	}
}
