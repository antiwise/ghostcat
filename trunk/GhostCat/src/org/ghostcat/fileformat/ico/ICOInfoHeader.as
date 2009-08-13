/**
 * com.voidelement.images.ico.ICODecoder  Class for ActionScript 3.0 
 *  
 * @author       Copyright (c) 2008 munegon
 * @version      1.0
 *  
 * @link         http://www.voidelement.com/
 * @link         http://void.heteml.jp/blog/
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); 
 * you may not use this file except in compliance with the License. 
 * You may obtain a copy of the License at 
 *  
 * http://www.apache.org/licenses/LICENSE-2.0 
 *  
 * Unless required by applicable law or agreed to in writing, software 
 * distributed under the License is distributed on an "AS IS" BASIS, 
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,  
 * either express or implied. See the License for the specific language 
 * governing permissions and limitations under the License. 
 */



package org.ghostcat.fileformat.ico {
	import flash.errors.IOError;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class ICOInfoHeader {
		private const INFO_HEADER_SIZE:uint = 16;
		
		
		private var _width:uint;
		public function get width():uint { return _width; }
		
		private var _height:uint;
		public function get height():uint { return _height; }
		
		private var _count:uint;
		public function get count():uint { return _count; }
		
		private var _xHotSpot:uint;
		public function get xHotSpot():uint { return _xHotSpot; }
		
		private var _yHotSpot:uint;
		public function get yHotSpot():uint { return _yHotSpot; }
		
		private var _size:uint;
		public function get size():uint { return _size; }
		
		private var _offset:uint;
		public function get offset():uint { return _offset; }
		
		
		public function ICOInfoHeader( stream:ByteArray ) {
			var bytes:ByteArray = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;
			
			try {
				stream.readBytes( bytes, 0, INFO_HEADER_SIZE );
				
				_width = bytes.readUnsignedByte() || 256;
				_height = bytes.readUnsignedByte() || 256;
				_count = bytes.readUnsignedByte() || 256;
				
				bytes.position += 1; // reserved
				
				_xHotSpot = bytes.readUnsignedShort();
				_yHotSpot = bytes.readUnsignedShort();
				_size = bytes.readUnsignedInt();
				_offset = bytes.readUnsignedInt();
			} catch ( e:IOError ) {
				trace("error: icon info header");
				throw new VerifyError("invalid icon info header");
			}
		}
	}
}