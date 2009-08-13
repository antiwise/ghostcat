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
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import org.ghostcat.fileformat.zip.ZipArchive;
	import org.ghostcat.fileformat.zip.ZipInflater;
	import org.ghostcat.fileformat.zip.ZipFile;
	import org.ghostcat.fileformat.zip.ZipTag;
	import org.ghostcat.fileformat.zip.ZipEvent;
	
	/**
	 * @private
	 */
	internal class ZipParser extends EventDispatcher {
		private var data:ByteArray;
		private var zip:ZipArchive;
		private namespace localfile;
		public function ZipParser() {
		}
		internal function writeZipFromFile(zip:ZipArchive, filename:String):void {
			if (!zip) return;
			this.zip = zip;
			data = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			load(filename);
		}
		internal function writeZipFromStream(zip:ZipArchive, data:ByteArray):void {
			if (!zip) return;
			this.zip = zip;
			this.data = data;
			data.position = 0;
			parse();
		}
		private function load(filename:String):void {
			var stream:URLStream = new URLStream();
			stream.load(new URLRequest(filename));
			stream.addEventListener(ProgressEvent.PROGRESS, fileloading);
			stream.addEventListener(Event.COMPLETE,fileLoaded);
			stream.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		private function onError(evt:IOErrorEvent):void {
			var stream:URLStream = evt.currentTarget as URLStream;
			stream.removeEventListener(ProgressEvent.PROGRESS, fileloading);
			stream.removeEventListener(Event.COMPLETE, fileLoaded);
			stream.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			zip.dispatchEvent(evt.clone());
		}
		private function fileloading(evt:ProgressEvent):void {
			zip.dispatchEvent(evt.clone());
		}
		private function fileLoaded(evt:Event):void {
			var stream:URLStream = evt.currentTarget as URLStream;
			stream.removeEventListener(ProgressEvent.PROGRESS, fileloading);
			stream.removeEventListener(Event.COMPLETE, fileLoaded);
			stream.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			stream.readBytes(data);
			parse();
		}
		private function parse():void {
			try {
				while (parseFile()) { }
				dispatchEvent(new ZipEvent(ZipEvent.ZIP_PARSE_COMPLETED));
			}catch (e:Error) {
				zip.dispatchEvent(new ZipEvent(ZipEvent.ZIP_FAILED, e.message));
				trace(e);
			}
			data = null;
		}
		private function parseFile():Boolean {
			var tag:uint = data.readUnsignedInt();
			switch(tag) {
				//0x04034b50
				case ZipTag.LOCSIG:
				var file:ZipFile = new ZipFile();
				localfile::parseHeader(file);
				if (file._nameLength || file._extraLength) localfile::parseExt(file);
				localfile::parseContent(file);
				//保存文件到zip档案
				zip._list.push(file);
				if (file._name) zip._entry[file._name] = file;
				return true;
				//0x06054b50
				case ZipTag.ENDSIG:
				return true;
				//0x02014b50
				case ZipTag.CENSIG:
				return true;
			}
			return false;
		}
		localfile function parseContent(file:ZipFile):void {
			if (!file._compressedSize) return;
			var compressedData:ByteArray = new ByteArray();
			data.readBytes(compressedData, 0, file._compressedSize);
			switch(file._compressionMethod) {
				//存取模式STORED
				case ZipTag.STORED:
				file._data=compressedData;
				break;
				//压缩模式DEFLATED
				case ZipTag.DEFLATED:
				var ba:ByteArray = new ByteArray();
				var inflater:ZipInflater = new ZipInflater();
				inflater.setInput(compressedData);
				inflater.inflate(ba);
				file._data = ba;
				break;
				default:
				throw new Error("invalid compression method");
			}
		}
		localfile function parseExt(file:ZipFile):void {
			if (file._encoding == "utf-8") file._name = data.readUTFBytes(file._nameLength);
			else file._name = data.readMultiByte(file._nameLength, file._encoding);
			var len:uint = file._extraLength;
			if (len > 4) {
				var id:uint = data.readUnsignedShort();
				var size:uint = data.readUnsignedShort();
				if (size > len) throw new Error("Parse Error: extra field data size too big");
				if (id === 0xdada && size === 4) {
				}else if (size > 0) {
					file._extra = new ByteArray();
					data.readBytes(file._extra, 0, size);
				}
				len -= size + 4;
			}
			if (len > 0) data.position += len;
		}
		localfile function parseHeader(file:ZipFile):void {
			file._version = data.readUnsignedShort();
			file._flag = data.readUnsignedShort();
			file._compressionMethod = data.readUnsignedShort();
			file._encrypted = (file._flag & 0x01) !== 0;
			if ((file._flag & 800) !== 0) file._encoding = "utf-8";
			file._dostime = data.readUnsignedInt();
			file._crc32 = data.readUnsignedInt();
			file._compressedSize = data.readUnsignedInt();
			file._size = data.readUnsignedInt();
			file._nameLength = data.readUnsignedShort();
			file._extraLength = data.readUnsignedShort();
		}
	}
}
