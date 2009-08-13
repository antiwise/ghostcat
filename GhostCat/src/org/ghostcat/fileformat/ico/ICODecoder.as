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
	import flash.display.BitmapData;
	import flash.errors.IOError;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class ICODecoder {
		private static var _verbose:Boolean = false;
		private static function get verbose():Boolean { return _verbose; }
		private static function set verbose( value:Boolean ):void { _verbose = value; }
		
		
		private var _header:ICOFileHeader;
		public function get header():ICOFileHeader { return _header; }
		
		
		/**
		 * コンストラクタ
		 */
		public function ICODecoder() {
			
		}
		
		
		/**
		 * デコード
		 * 
		 * @param デコードしたいICOファイルのバイナリデータ
		 */
		public function decode( stream:ByteArray ):Array {
			_header = new ICOFileHeader( stream );
			
			var info_arr:Array = new Array();
			for ( var i:int = 0; i < header.num; ++i ) {
				info_arr.push( new ICOInfoHeader( stream ) );
			}
			
			var image_arr:Array = new Array();
			for ( var j:int = 0; j < header.num; ++j ) {
				image_arr.push( new ICOImageData( stream ) );	
			}
			
			return image_arr;
		}
		
		
		/**
		 * ログ出力
		 */
		public static function log( message:String ):void {
			if ( verbose ) {
				trace( message );
			}
		}
	}
}

