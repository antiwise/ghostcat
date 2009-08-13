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
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.errors.IOError;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class ICOImageData {
		private const COMP_RGB      :int = 0;
		private const COMP_RLE8     :int = 1;
		private const COMP_RLE4     :int = 2;
		private const COMP_BITFIELDS:int = 3;
		
		private const BIT1 :int = 1;
		private const BIT4 :int = 4;
		private const BIT8 :int = 8;
		private const BIT16:int = 16;
		private const BIT24:int = 24;
		private const BIT32:int = 32;
		
		
		private var _image:BitmapData;
		public function get image():BitmapData { return _image; }
		
		private var _mask:BitmapData;
		public function get mask():BitmapData { return _mask; }
		
		private var _info:BitmapInfoHeader;
		public function get info():BitmapInfoHeader { return _info; }
		
		private var _palette:Array;
		public function get palette():Array { return _palette; }
		
		
		private var nRMask:uint;
		private var nGMask:uint;
		private var nBMask:uint;
		private var nRPos:uint = 0;
		private var nGPos:uint = 0;
		private var nBPos:uint = 0;
		private var nRMax:uint;
		private var nGMax:uint;
		private var nBMax:uint;
		
		
		public function ICOImageData( stream:ByteArray ) {
			_info = new BitmapInfoHeader( stream );
			_image = new BitmapData( info.width, info.height, true );
			
			stream.endian = Endian.LITTLE_ENDIAN;
			
			ICODecoder.log("bpp: " + info.bitsPerPixel );
			ICODecoder.log("comp: " + info.compression );
			ICODecoder.log("used: " + info.colorUsed );
			ICODecoder.log("impo: " + info.colorImportant );
			
			switch ( info.bitsPerPixel ){
				case BIT1:
					readColorPalette( stream );
					decode1BitBMP( stream );
					decodeMaskData( stream );
					break;
				case BIT4:
					readColorPalette( stream );
					if ( info.compression == COMP_RLE4 ){
						decode4bitRLE( stream );
					} else {
						decode4BitBMP( stream );
					}
					decodeMaskData( stream );
					break;
				case BIT8:
					readColorPalette( stream );
					if ( info.compression == COMP_RLE8 ){
						decode8BitRLE( stream );
					} else {
						decode8BitBMP( stream );
					}
					decodeMaskData( stream );
					break;
				case BIT16:
					readBitFields( stream );
					checkColorMask();
					decode16BitBMP( stream );
					decodeMaskData( stream );
					break;
				case BIT24:
					decode24BitBMP( stream );
					decodeMaskData( stream );
					break;
				case BIT32:
					readBitFields( stream );
					checkColorMask();
					decode32BitBMP( stream );
					decodeMaskData( stream );
					break;
				default:
					throw new VerifyError("invalid bits per pixel : " + info.bitsPerPixel );
			}
		}
		
		/**
		 * ビットフィールド読み込み
		 */
		private function readBitFields( stream:ByteArray ):void {
			if ( info.compression == COMP_RGB ){
				if ( info.bitsPerPixel == BIT16 ){
					// RGB555
					nRMask = 0x00007c00;
					nGMask = 0x000003e0;
					nBMask = 0x0000001f;
				} else {
					//RGB888;
					nRMask = 0x00ff0000;
					nGMask = 0x0000ff00;
					nBMask = 0x000000ff;
				}
			} else if ( info.compression == COMP_BITFIELDS ){
				try {
					nRMask = stream.readUnsignedInt();
					nGMask = stream.readUnsignedInt();
					nBMask = stream.readUnsignedInt();
				} catch ( e:IOError ) {
					throw new VerifyError("invalid bit fields");
				}
			}
		}
		
		
		/**
		 * カラーパレット読み込み
		 */
		private function readColorPalette( stream:ByteArray ):void {
			var i:int;
			var len:int = ( info.colorUsed > 0 ) ? info.colorUsed : Math.pow( 2, info.bitsPerPixel );
			
			_palette = new Array( len );
			
			for ( i = 0; i < len; ++i ){
				palette[ i ] = stream.readUnsignedInt();
			}
		}
		
		
		/**
		 * 1bitのBMPデコード
		 */
		private function decode1BitBMP( stream:ByteArray ):void {
			var x:int;
			var y:int;
			var i:int;
			var col:int;
			var buf:ByteArray = new ByteArray();
			var line:int = info.width / 8;
			
			if ( line % 4 > 0 ){
				line = ( ( line / 4 | 0 ) + 1 ) * 4;
			}
			
			try {
				for ( y = info.height - 1; y >= 0; --y ){
					buf.length = 0;
					stream.readBytes( buf, 0, line );
					
					for ( x = 0; x < info.width; x += 8 ){
						col = buf.readUnsignedByte();
						
						for ( i = 0; i < 8; ++i ){
							image.setPixel( x + i, y, palette[ col >> ( 7 - i ) & 0x01 ] );
						}
					}
				}
			} catch ( e:IOError ) {
				throw new VerifyError("invalid image data");
			}
		}
		
		
		/**
		 * 4bitのRLE圧縮BMPデコード
		 */
		private function decode4bitRLE( stream:ByteArray ):void {
			var x:int;
			var y:int;
			var i:int;
			var n:int;
			var col:int;
			var data:uint;
			var buf:ByteArray = new ByteArray();
			
			try {
				for ( y = info.height - 1; y >= 0; --y ){
					buf.length = 0;
					
					while ( stream.bytesAvailable > 0 ){
						n = stream.readUnsignedByte();
						
						if ( n > 0 ){
							// エンコードデータ
							data = stream.readUnsignedByte();
							for ( i = 0; i < n/2; ++i ){
								buf.writeByte( data );
							}
						} else {
							n = stream.readUnsignedByte();
							
							if ( n > 0 ){
								// 絶対モードデータ
								stream.readBytes( buf, buf.length, n/2 );
								buf.position += n/2;
								
								if ( n/2 + 1 >> 1 << 1 != n/2 ){
									stream.readUnsignedByte();
								}
							} else {
								// EOL
								break;
							}
						}
					}
					
					buf.position = 0;
					
					for ( x = 0; x < info.width; x += 2 ){
						col = buf.readUnsignedByte();
						
						image.setPixel( x, y, palette[ col >> 4 ] );
						image.setPixel( x + 1, y, palette[ col & 0x0f ] );
					}
				}
			} catch ( e:IOError ) {
				throw new VerifyError("invalid image data");
			}
		}
		
		
		/**
		 * 4bitの非圧縮BMPデコード
		 */
		private function decode4BitBMP( stream:ByteArray ):void {
			var x:int;
			var y:int;
			var i:int;
			var col:int;
			var buf:ByteArray = new ByteArray();
			var line:int = info.width / 2;
			
			if ( line % 4 > 0 ){
				line = ( ( line / 4 | 0 ) + 1 ) * 4;
			}
			
			try {
				for ( y = info.height - 1; y >= 0; --y ){
					buf.length = 0;
					stream.readBytes( buf, 0, line );
					
					for ( x = 0; x < info.width; x += 2 ){
						col = buf.readUnsignedByte();
						
						image.setPixel( x, y, palette[ col >> 4 ] );
						image.setPixel( x + 1, y, palette[ col & 0x0f ] );
					}
				}
			} catch ( e:IOError ) {
				throw new VerifyError("invalid image data");
			}
		}
		
		
		/**
		 * 8bitのRLE圧縮BMPデコード
		 */
		private function decode8BitRLE( stream:ByteArray ):void {
			var x:int;
			var y:int;
			var i:int;
			var n:int;
			var col:int;
			var data:uint;
			var buf:ByteArray = new ByteArray();
			
			try {
				for ( y = info.height - 1; y >= 0; --y ){
					buf.length = 0;
					
					while ( stream.bytesAvailable > 0 ){
						n = stream.readUnsignedByte();
						
						if ( n > 0 ){
							// エンコードデータ
							data = stream.readUnsignedByte();
							for ( i = 0; i < n; ++i ){
								buf.writeByte( data );
							}
						} else {
							n = stream.readUnsignedByte();
							
							if ( n > 0 ){
								// 絶対モードデータ
								stream.readBytes( buf, buf.length, n );
								buf.position += n;
								if ( n + 1 >> 1 << 1 != n ){
									stream.readUnsignedByte();
								}
							} else {
								// EOL
								break;
							}
						}
					}
					
					buf.position = 0;
					
					for ( x = 0; x < info.width; ++x ){
						image.setPixel( x, y, palette[ buf.readUnsignedByte() ] );
					}
				}
			} catch ( e:IOError ) {
				throw new VerifyError("invalid image data");
			}
		}
		
		/**
		 * 8bitの非圧縮BMPデコード
		 */
		private function decode8BitBMP( stream:ByteArray ):void {
			var x:int;
			var y:int;
			var i:int;
			var col:int;
			var buf:ByteArray = new ByteArray();
			var line:int = info.width;
			
			if ( line % 4 > 0 ){
				line = ( ( line / 4 | 0 ) + 1 ) * 4;
			}
			
			try {
				for ( y = info.height - 1; y >= 0; --y ){
					buf.length = 0;
					stream.readBytes( buf, 0, line );
					
					for ( x = 0; x < info.width; ++x ){
						image.setPixel( x, y, palette[ buf.readUnsignedByte() ] );
					}
				}
			} catch ( e:IOError ) {
				throw new VerifyError("invalid image data");
			}
		}
		
		/**
		 * 16bitのBMPデコード
		 */
		private function decode16BitBMP( stream:ByteArray ):void {
			var x:int;
			var y:int;
			var col:int;
			
			try {
				for ( y = info.height - 1; y >= 0; --y ){
					for ( x = 0; x < info.width; ++x ){
						col = stream.readUnsignedShort();
						image.setPixel( x, y, ( ( ( col & nRMask ) >> nRPos )*0xff/nRMax << 16 ) + ( ( ( col & nGMask ) >> nGPos )*0xff/nGMax << 8 ) + ( ( ( col & nBMask ) >> nBPos )*0xff/nBMax << 0 ) );
					}
				}
			} catch ( e:IOError ) {
				throw new VerifyError("invalid image data");
			}
		}
		
		/**
		 * 24bitのBMPデコード
		 */
		private function decode24BitBMP( stream:ByteArray ):void {
			var x:int;
			var y:int;
			var col:int;
			var buf:ByteArray = new ByteArray();
			var line:int = info.width * 3;
			
			if ( line % 4 > 0 ){
				line = ( ( line / 4 | 0 ) + 1 ) * 4;
			}
			
			try {
				for ( y = info.height - 1; y >= 0; --y ){
					buf.length = 0;
					stream.readBytes( buf, 0, line );
					
					for ( x = 0; x < info.width; ++x ){
						image.setPixel( x, y, buf.readUnsignedByte() + ( buf.readUnsignedByte() << 8 ) + ( buf.readUnsignedByte() << 16 ) );
					}
				}
			} catch ( e:IOError ) {
				throw new VerifyError("invalid image data");
			}
		}
		
		/**
		 * 32bitのBMPデコード
		 */
		private function decode32BitBMP( stream:ByteArray ):void {
			var x:int;
			var y:int;
			var col:int;
			
			try {
				for ( y = info.height - 1; y >= 0; --y ){
					for ( x = 0; x < info.width; ++x ){
						col = stream.readUnsignedInt();
						image.setPixel( x, y, ( ( ( col & nRMask ) >> nRPos )*0xff/nRMax << 16 ) | ( ( ( col & nGMask ) >> nGPos )*0xff/nGMax << 8 ) | ( ( ( col & nBMask ) >> nBPos )*0xff/nBMax << 0 ) );
					}
				}
			} catch ( e:IOError ) {
				throw new VerifyError("invalid image data");
			}
		}
		
		
		/**
		 * 透過マスクデコード
		 */
		private function decodeMaskData( stream:ByteArray ):void {
			_mask = new BitmapData( info.width, info.height, false, 0xffffff );
			
			stream.endian = Endian.BIG_ENDIAN;
			
			try {
				for ( var y:int = info.height - 1; y >= 0; --y ) {
					var alpha:uint = stream.readUnsignedInt() >>> ( 32 - info.width );
					
					for ( var x:int = 0; x < info.width; ++x ) {
						if ( ( alpha >>> ( info.width - 1 - x ) ) & 1 ) {
							mask.setPixel( x, y, 0x000000 );
						}
					}
				}
			} catch ( e:IOError ) {
				throw new VerifyError("invalid mask data");
			}
			
			image.copyChannel( mask, mask.rect, mask.rect.topLeft, BitmapDataChannel.BLUE, BitmapDataChannel.ALPHA );
		}
		
		
		/**
		 * カラーマスクチェック
		 */
		private function checkColorMask():void {
			if ( ( nRMask & nGMask ) | ( nGMask & nBMask ) | ( nBMask & nRMask ) ){
				throw new VerifyError("invalid bit fields");
			}
			
			while ( ( ( nRMask >> nRPos ) & 0x00000001 ) == 0 ){
				nRPos++;
			}
			while ( ( ( nGMask >> nGPos ) & 0x00000001 ) == 0 ){
				nGPos++;
			}
			while ( ( ( nBMask >> nBPos ) & 0x00000001 ) == 0 ){
				nBPos++;
			}
			
			nRMax = nRMask >> nRPos;
			nGMax = nGMask >> nGPos;
			nBMax = nBMask >> nBPos;
		}
	}
}