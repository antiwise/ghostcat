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
	
	public class BitmapInfoHeader {
		private const BITMAP_INFO_HEADER_SIZE:uint = 40;
		
		
		private var _width:int;
		public function get width():int { return _width; }
		
		private var _height:int;
		public function get height():int { return _height; }
		
		private var _planes:uint;
		public function get planes():uint { return _planes; }
		
		private var _bitsPerPixel:uint;
		public function get bitsPerPixel():uint { return _bitsPerPixel; }
		
		private var _compression:uint;
		public function get compression():uint { return _compression; }
		
		private var _sizeImage:uint;
		public function get sizeImage():uint { return _sizeImage; }
		
		private var _xPixPerMeter:int;
		public function get xPixPerMeter():int { return _xPixPerMeter; }
		
		private var _yPixPerMeter:int;
		public function get yPixPerMeter():int { return _yPixPerMeter; }
		
		private var _colorUsed:uint;
		public function get colorUsed():uint { return _colorUsed; }
		
		private var _colorImportant:uint;
		public function get colorImportant():uint { return _colorImportant; }
		
		
		public function BitmapInfoHeader( stream:ByteArray ) {
			var bytes:ByteArray = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;
			
			try {
				stream.readBytes( bytes, 0, BITMAP_INFO_HEADER_SIZE );
				
				if ( bytes.readUnsignedInt() != BITMAP_INFO_HEADER_SIZE ) {
					throw new VerifyError("invalid bitmap info header size");
				}
				
				_width  = bytes.readInt();
				_height = bytes.readInt() / 2;
				_planes = bytes.readUnsignedShort();
				_bitsPerPixel = bytes.readUnsignedShort();
				
				_compression = bytes.readUnsignedInt();
				_sizeImage = bytes.readUnsignedInt();
				_xPixPerMeter = bytes.readInt();
				_yPixPerMeter = bytes.readInt();
				_colorUsed = bytes.readUnsignedInt();
				_colorImportant = bytes.readUnsignedInt();
			} catch ( e:IOError ) {
				throw new VerifyError("invalid bitmap info header");
			}
		}
	}
}
