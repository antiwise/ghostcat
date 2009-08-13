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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import org.ghostcat.fileformat.zip.ZipFile;
	import org.ghostcat.fileformat.zip.ZipParser;
	import org.ghostcat.fileformat.zip.ZipEvent;
	import org.ghostcat.fileformat.zip.CRC32;
	
	/**
	 * 使用ZipArchive类，你可以轻松操作各种Zip文件，如.zip/.air/.docx/.xlsx等。
	 * @langversion ActionScript 3.0
	 * @playerversion Flash Player 9.0
	 */
	public class ZipArchive extends EventDispatcher{
		
		private var _name:String;
		/**
		 * @private
		 */
		internal var _list:Array;
		/**
		 * @private
		 */
		internal var _entry:Dictionary;
		/**
		 * 构造函数，创建一个新的Zip档案。
		 */
		public function ZipArchive(name:String = null) {
			_list = [];
			_entry = new Dictionary(true);
			if (name)_name = name;
		}
		/**
		 * 加载一个zip档案，与此方法的事件有ProgressEvent.PROGRESS、ZipEvent.ZIP_INIT、ZipEvent.ZIP_FAILED、IOErrorEvent.IO_ERROR。
		 * @param	request 要加载的zip档案地址。
		 */
		public function load(request:String):void {
			try {
				if (!_name)_name = request;
				var parser:ZipParser = new ZipParser();
				parser.addEventListener(ZipEvent.ZIP_PARSE_COMPLETED, parseCompleted);
				parser.writeZipFromFile(this, request);
			}catch (e:Error) { }
		}
		/**
		 * 打开一个二进制流的zip档案。
		 * @param	data 二进制流的zip档案。
		 * @return  成功打开返回true，否则返回false。
		 */
		public function open(data:ByteArray):Boolean {
			try {
				var parser:ZipParser = new ZipParser();
				parser.writeZipFromStream(this, data);
				return true;
			}catch (e:Error) { }
			return false;
		}
		/**
		 * 添加指定的zip文件到档案。
		 * @param	file 指定的zip文件。
		 * @param	index 指定的位置，默认值为-1，即在末尾添加文件。
		 * @return
		 */
		public function addFile(file:ZipFile, index:int=-1):ZipFile {
			if (file) {
				if (index<0 || index >= _list.length)_list.push(file);
				else _list.splice(index, 0, file);
				_entry[name] = file;
				return file;
			}
			return null;
		}
		/**
		 * 根据指定的名称和二进制数据添加文件到zip档案。
		 * @param	name 指定文件的名字。
		 * @param	data 指定文件的二进制数据。
		 * @param	index 指定文件的位置，默认值为-1，即在末尾添加文件。
		 * @return
		 */
		public function addFileFromBytes(name:String, data:ByteArray = null, index:int=-1):ZipFile {
			if (_entry[name]) throw new Error("file: "+name+" already exists.");
			var file:ZipFile = new ZipFile(name);
			try {
				data.uncompress();
			}catch (e:Error) { }
			data.position = 0;
			file._data = data;
			file.date = new Date();
			file._size = data.length;
			file._version = 20;
			file._flag = 0;
			file._crc32 = new CRC32().getCRC32(data);
			if (index<0 || index >= _list.length)_list.push(file);
			else _list.splice(index, 0, file);
			_entry[name] = file;
			return file;
		}
		/**
		 * 根据指定的字符串内容添加文件到zip档案。
		 * @param	name 指定文件的名字。
		 * @param	content 指定的字符串内容。
		 * @param	index 指定文件的位置，默认值为-1，即在末尾添加文件。
		 * @return
		 */
		public function addFileFromString(name:String, content:String, index:int=-1):ZipFile {
			if (content == null) return null;
			//默认utf-8进行编码
			var data:ByteArray = new ByteArray();
			data.writeUTFBytes(content);
			return addFileFromBytes(name, data, index);
		}
		
		/**
		 * 根据文件名获取Zip档案中的文件。
		 * @param	name 名称。
		 * @return
		 */
		public function getFileByName(name:String):ZipFile {
			return _entry[name] ? _entry[name] : null;
		}
		/**
		 * 根据文件位置获取Zip档案中的文件。
		 * @param	index 位置ID。
		 * @return
		 */
		public function getFileAt(index:uint):ZipFile {
			return (_list.length > index) ? _list[index] : null;
		}
		/**
		 * 根据图片文件名称获取Zip档案中的文件，与此方法的事件有ZipEvent.ZIP_CONTENT_LOADED。
		 * @param	name 名称。
		 */
		public function getBitmapByName(name:String):void {
			var file:ZipFile = getFileByName(name);
			if (!file) return;
			file.data.position = 0;
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, getBitmapCompleted);
			loader.loadBytes(file.data);
		}
		/**
		 * 删除Zip档案中的指定名称的文件。
		 * @param	name 指定文件的名字。
		 * @return
		 */
		public function removeFileByName(name:String):ZipFile {
			if (_entry[name]) {
				for (var i:uint = 0; i < _list.length; i++) {
					if (name == _list[i].name) return removeFileAt(i);
				}
			}
			return null;
		}
		/**
		 * 删除Zip档案中的指定位置的文件。
		 * @param	index 指定的位置。
		 * @return
		 */
		public function removeFileAt(index:uint):ZipFile {
			if (index < _list.length) {
				var file:ZipFile = _list[index];
				if (file) {
					_list.splice(index, 1);
					delete _entry[file.name];
					return file;
				}
			}
			return null;
		}
		/**
		 * 输出序列化的Zip档案。
		 * @param	method 指定压缩模式，一般为DEFLATED或STORED。
		 */
		public function output(method:uint = 8):ByteArray {
			var zs:ZipSerializer = new ZipSerializer();
			return zs.serialize(this, method) as ByteArray;
		}
		private function parseCompleted(evt:ZipEvent):void {
			var parser:ZipParser = evt.currentTarget as ZipParser;
			parser.removeEventListener(ZipEvent.ZIP_PARSE_COMPLETED, parseCompleted);
			parser = null;
			if(_list.length==0)dispatchEvent(new ZipEvent(ZipEvent.ZIP_FAILED,"unsupported or unknow format"));
			else dispatchEvent(new ZipEvent(ZipEvent.ZIP_INIT));
		}
		/**
		 * 根据图片文件名称获取zip文件成功后，广播ZIP_CONTENT_LOADED事件。
		 * @param	evt evt.content为加载图像的bitmap对象。
		 */
		private function getBitmapCompleted(evt:Event):void {
			var info:LoaderInfo = evt.currentTarget as LoaderInfo;
			info.removeEventListener(Event.COMPLETE, getBitmapCompleted);
			dispatchEvent(new ZipEvent(ZipEvent.ZIP_CONTENT_LOADED,info.content));
		}
		
		//getters & setters & toString
		
		/**
		 * 设置和获取Zip档案名称。
		 */
		public function get name():String {
			return _name;
		}
		public function set name(name:String):void {
			this._name = name;
		}
		/**
		 * 获取Zip档案里的文件数。
		 */
		public function get length():uint {
			return _list.length;
		}
		/**
		 * 覆盖默认的toString方法，其中包含ZipArchive对象里的所有ZipFile对象信息。
		 * @return ZipArchive对象的字符串表现形式。
		 */
		public override function toString():String {
			var str:String = "[ZipArchive Name=\""+name+"\"]\r";
			for (var i:int = 0; i < length; i++)
			str += "Index:" + i + " --> " + _list[i].toString();
			return str + "\r";
		}
	}
}
