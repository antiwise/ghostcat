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



package org.ghostcat.fileformat.ico{
	import flash.errors.IOError;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class ICOFileHeader {
		private const FILE_HEADER_SIZE:uint = 6;
		
		
		private var _type:uint;
		public function get type():uint { return _type; }
		
		private var _num:uint;
		public function get num():uint { return _num; }
		
		
		public function ICOFileHeader( stream:ByteArray ) {
			var bytes:ByteArray = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;
			
			try {
				stream.readBytes( bytes, 0, FILE_HEADER_SIZE );
				
				if ( bytes.readShort() != 0x00 ){
					throw new VerifyError("invalid icon file header signature");
				}
				
				_type = bytes.readUnsignedShort();
				_num = bytes.readUnsignedShort();
			} catch ( e:IOError ) {
				throw new VerifyError("invalid file icon header size");
			}
		}
	}
}