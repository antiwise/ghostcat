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
	import flash.utils.IDataOutput;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import org.ghostcat.fileformat.zip.ZipArchive;
	import org.ghostcat.fileformat.zip.ZipFile;
	import org.ghostcat.fileformat.zip.ZipTag;
	
	/**
	 * @private
	 */
	internal class ZipSerializer {
		//序列化状态
		private namespace header;
		private namespace zipfile;
		private namespace zipend;
		//存储序列化后数据
		private var stream:ByteArray;
		
		public function ZipSerializer() {
		}
		public function serialize(zip:ZipArchive, method:uint = 8):ByteArray {
			if (!zip.length) return null;
			stream = new ByteArray();
			var centralData:ByteArray = new ByteArray();
			stream.endian = centralData.endian = Endian.LITTLE_ENDIAN;
			var offset:uint;
			for (var i:uint = 0, filenum:uint = zip.length; i < filenum; i++) {
				var file:ZipFile = zip.getFileAt(i);
				//生成文件数据the local file data
				var data:ByteArray = zipfile::serialize(file, method);
				//写入zip文件头the local file header
				header::serialize(stream, file, true);
				//写入文件数据
				stream.writeBytes(data);
				//写入中央目录到临时centralData中
				header::serialize(centralData, file, false, offset);
				offset = stream.position;
			}
			//写入中央目录central directory file header
			stream.writeBytes(centralData);
			//写入中央目录尾the end of central directory
			zipend::serialize(offset, stream.length - offset, filenum);
			return stream;
		}
		/**
		 * 串行化zip文件头和中央目录
		 * @param   stream 指定写入的ByteArray对象
		 * @param	file 指定串行化文件
		 * @param	local 指定是zip文件头还是中央目录
		 * @param	offset 指定文件位置偏移量
		 */
		header function serialize(stream:ByteArray, file:ZipFile, local:Boolean = true, offset:uint = 0):void {
			//写入文件头
			if (local) {
				stream.writeUnsignedInt(ZipTag.LOCSIG);
			}else {
				stream.writeUnsignedInt(ZipTag.CENSIG);
				stream.writeShort(file._version);
			}
			stream.writeShort(file._version);
			stream.writeShort(file._flag);
			stream.writeShort(file._compressionMethod);
			stream.writeUnsignedInt(file._dostime);
			stream.writeUnsignedInt(file._crc32);
			stream.writeUnsignedInt(file._compressedSize);
			stream.writeUnsignedInt(file._size);
			//获取文件名长度
			var ba:ByteArray = new ByteArray();
			if (file._encoding == "utf-8") {
				ba.writeUTFBytes(file._name);
			} else {
				ba.writeMultiByte(file._name, file._encoding);
			}
			file._nameLength = ba.position;
			stream.writeShort(file._nameLength);
			stream.writeShort(file._extra ? file._extra.length : 0);
			if (!local) {
				stream.writeShort(file._comment ? file._comment.length : 0);
				stream.writeShort(0);
				stream.writeShort(0);
				stream.writeUnsignedInt(0);
				stream.writeUnsignedInt(offset);
			}
			stream.writeBytes(ba);
			if (file._extra) stream.writeBytes(file._extra);
			if (!local && file._comment) stream.writeUTFBytes(file._comment);
		}
		/**
		 * 根据压缩方式串行化文件数据
		 * @param	file 指定串行化文件
		 * @param   compressionMethod 指定压缩方法，一般为DEFLATE和STORE两种方式
		 */
		zipfile function serialize(file:ZipFile, compressionMethod:uint = 8):ByteArray {
			file._compressionMethod = compressionMethod;
			file._flag = 0;
			var data:ByteArray = new ByteArray();
			data.writeBytes(file.data);
			if (compressionMethod == ZipTag.DEFLATED) {
				try {
					data.compress();
				}catch (e:Error) { }
				file._compressedSize = data.length - 6;
				var tmpdata:ByteArray = new ByteArray();
				tmpdata.writeBytes(data, 2, data.length - 6);
				return tmpdata;
			}else if (compressionMethod == ZipTag.STORED) {
				file._compressedSize = data.length;
			}
			return data;
		}
		/**
		 * 串行化zip文件尾
		 * @param	offset
		 * @param	length
		 */
		zipend function serialize(offset:uint, length:uint, filenum:uint):void {
			//写入主要文件尾
			stream.writeUnsignedInt(ZipTag.ENDSIG);
			stream.writeShort(0);
			stream.writeShort(0);
			//写入当前磁盘文件总数
			stream.writeShort(filenum);
			//写入文件总数
			stream.writeShort(filenum);
			//写入文件总长度
			stream.writeUnsignedInt(length);
			stream.writeUnsignedInt(offset);
			//写入注释长度，总为0
			stream.writeShort(0);
		}
	}
}
