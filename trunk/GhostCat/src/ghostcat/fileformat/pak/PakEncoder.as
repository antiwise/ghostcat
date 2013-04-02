package ghostcat.fileformat.pak
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import ghostcat.fileformat.jpg.JPGEncoder;
	import ghostcat.fileformat.png.PNGEncoder;

	public class PakEncoder extends EventDispatcher
	{
		public var list:Array;
		public var type:int;
		public var quality:int;
		public var alphaQuality:int;
		public var alphaFilter:int;
		
		public var bytes:ByteArray;
		
		public function PakEncoder(list:Array,type:int = 1,quality:int = 50,alphaQuality:int = 50,alphaFilter:int = 50)
		{
			this.list = list;
			this.type = type;
			this.quality = quality;
			this.alphaQuality = alphaQuality;
			this.alphaFilter = alphaFilter;
			
			if (list)
				this.encode();
		}
		
		public function encode():void
		{
			if (type == 1)
				encode1();
			else if (type == 2)
				encode2();
		}
		
		public function encodeByPak(pak:PakDecoder,start:int,len:int):void
		{
			if (pak.type != 2)
				return;
			
			this.type = pak.type;
			this.quality = pak.quality;
			this.alphaQuality = pak.alphaQuality;
			this.alphaFilter = pak.alphaFilter;
			
			bytes = new ByteArray();
			bytes.writeByte(type);
			bytes.writeShort(pak.width);
			bytes.writeShort(pak.height);
			bytes.writeByte(quality);
			bytes.writeByte(alphaQuality);
			bytes.writeByte(alphaFilter);
			bytes.writeShort(len);
			
			var mh:int = 0;
			var tw:int = 0;
			var rects:Array = [];
			for (var i:int = 0; i < len;i++)
			{
				var offest:Point = pak.offests[start+i];
				var size:Point = pak.sizes[start+i];
				bytes.writeShort(offest.x);
				bytes.writeShort(offest.y);
				bytes.writeShort(size.x);
				bytes.writeShort(size.y);
				
				if (alphaQuality == 0 || quality == alphaQuality)
				{
					var data:ByteArray = pak.loadList[start+i];
					bytes.writeUnsignedInt(data.length);
					bytes.writeBytes(data);
				}
				else
				{
					data = pak.loadList[(start+i)*2];
					bytes.writeUnsignedInt(data.length);
					bytes.writeBytes(data);
					
					if (alphaQuality)
					{
						var alphaData:ByteArray = pak.loadList[(start+i)*2+1];
						bytes.writeUnsignedInt(alphaData.length);
						bytes.writeBytes(alphaData);
					}
				}
			}
			bytes.compress();
		}
		
		private function encode1():void //合并
		{
			bytes = new ByteArray();
			bytes.writeByte(type);
			bytes.writeShort(list[0].width);
			bytes.writeShort(list[0].height);
			bytes.writeByte(quality);
			bytes.writeByte(alphaQuality);
			bytes.writeByte(alphaFilter);
			bytes.writeShort(list.length);
			
			var mh:int = 0;
			var tw:int = 0;
			var rects:Array = [];
			for each (var bmd:BitmapData in list)
			{
				var checkBitmap:BitmapData = bmd.clone();
				checkBitmap.threshold(checkBitmap,checkBitmap.rect,new Point(),">",0,0xFFFFFFFF,0xFFFFFFFF);
				var rect:Rectangle = checkBitmap.getColorBoundsRect(0xFFFFFFFF,0xFFFFFFFF,true);
				rects.push(rect);
				
				checkBitmap.dispose();
				
				if (rect.height > mh)
					mh = rect.height;
				
				bytes.writeShort(rect.x);
				bytes.writeShort(rect.y);
				bytes.writeShort(rect.width);
				bytes.writeShort(rect.height);
			
				tw += rect.width;
			}
			
			var newBmb:BitmapData = new BitmapData(tw,mh,true,0);
			var sx:int = 0;
			for (var i:int = 0;i < list.length;i++)
			{
				bmd = list[i];
				rect = rects[i];
				
				newBmb.copyPixels(bmd,rect,new Point(sx,0));
				
				sx += rect.width;
			}
			
			if (quality == alphaQuality)
			{
				var conBmd:BitmapData = new BitmapData(newBmb.width,newBmb.height * 2,false,0);
				conBmd.copyPixels(newBmb,newBmb.rect,new Point());
				conBmd.copyChannel(newBmb,newBmb.rect,new Point(0,newBmb.height),BitmapDataChannel.ALPHA,BitmapDataChannel.RED);
				conBmd.copyChannel(newBmb,newBmb.rect,new Point(0,newBmb.height),BitmapDataChannel.ALPHA,BitmapDataChannel.GREEN);
				conBmd.copyChannel(newBmb,newBmb.rect,new Point(0,newBmb.height),BitmapDataChannel.ALPHA,BitmapDataChannel.BLUE);
				
				var conData:ByteArray = quality == 100 ? PNGEncoder.encode(conBmd) : new JPGEncoder(quality).encode(conBmd);
				bytes.writeUnsignedInt(conData.length);
				bytes.writeBytes(conData);
				
				conBmd.dispose();
			}
			else
			{
				var data:ByteArray = quality == 100 ? PNGEncoder.encode(newBmb) : new JPGEncoder(quality).encode(newBmb);
				bytes.writeUnsignedInt(data.length);
				bytes.writeBytes(data);
				
				if (alphaQuality)
				{
					var alphaBmd:BitmapData = new BitmapData(newBmb.width,newBmb.height,false,0);
					alphaBmd.copyChannel(newBmb,newBmb.rect,new Point(),BitmapDataChannel.ALPHA,BitmapDataChannel.RED);
					alphaBmd.copyChannel(newBmb,newBmb.rect,new Point(),BitmapDataChannel.ALPHA,BitmapDataChannel.GREEN);
					alphaBmd.copyChannel(newBmb,newBmb.rect,new Point(),BitmapDataChannel.ALPHA,BitmapDataChannel.BLUE);
					var alphaData:ByteArray = alphaQuality == 100 ? PNGEncoder.encode(alphaBmd) : new JPGEncoder(alphaQuality).encode(alphaBmd);
					alphaBmd.dispose();
					
					bytes.writeUnsignedInt(alphaData.length);
					bytes.writeBytes(alphaData);
				}
				else
				{
					bytes.writeUnsignedInt(0);
				}
			}
			
			newBmb.dispose();
			bytes.compress();
		}
		
		private function encode2():void
		{
			bytes = new ByteArray();
			bytes.writeByte(type);
			bytes.writeShort(list[0].width);
			bytes.writeShort(list[0].height);
			bytes.writeByte(quality);
			bytes.writeByte(alphaQuality);
			bytes.writeByte(alphaFilter);
			bytes.writeShort(list.length);
			for each (var bmd:BitmapData in list)
			{
				var checkBitmap:BitmapData = bmd.clone();
				checkBitmap.threshold(checkBitmap,checkBitmap.rect,new Point(),">",0,0xFFFFFFFF,0xFFFFFFFF);
				var rect:Rectangle = checkBitmap.getColorBoundsRect(0xFFFFFFFF,0xFFFFFFFF,true);
				var newBmb:BitmapData = new BitmapData(rect.width,rect.height,true,0);
				newBmb.copyPixels(bmd,rect,new Point());
				checkBitmap.dispose();
				
				bytes.writeShort(rect.x);
				bytes.writeShort(rect.y);
				bytes.writeShort(rect.width);
				bytes.writeShort(rect.height);
				
				if (quality == alphaQuality)
				{
					var conBmd:BitmapData = new BitmapData(newBmb.width,newBmb.height * 2,false,0);
					conBmd.copyPixels(newBmb,newBmb.rect,new Point());
					conBmd.copyChannel(newBmb,newBmb.rect,new Point(0,newBmb.height),BitmapDataChannel.ALPHA,BitmapDataChannel.RED);
					conBmd.copyChannel(newBmb,newBmb.rect,new Point(0,newBmb.height),BitmapDataChannel.ALPHA,BitmapDataChannel.GREEN);
					conBmd.copyChannel(newBmb,newBmb.rect,new Point(0,newBmb.height),BitmapDataChannel.ALPHA,BitmapDataChannel.BLUE);
					
					var conData:ByteArray = quality == 100 ? PNGEncoder.encode(conBmd) : new JPGEncoder(quality).encode(conBmd);
					bytes.writeUnsignedInt(conData.length);
					bytes.writeBytes(conData);
					
					conBmd.dispose();
				}
				else
				{
					var data:ByteArray = quality == 100 ? PNGEncoder.encode(newBmb) :  new JPGEncoder(quality).encode(newBmb);
					bytes.writeUnsignedInt(data.length);
					bytes.writeBytes(data);
					
					if (alphaQuality)
					{
						var alphaBmd:BitmapData = new BitmapData(newBmb.width,newBmb.height,false,0);
						alphaBmd.copyChannel(newBmb,newBmb.rect,new Point(),BitmapDataChannel.ALPHA,BitmapDataChannel.RED);
						alphaBmd.copyChannel(newBmb,newBmb.rect,new Point(),BitmapDataChannel.ALPHA,BitmapDataChannel.GREEN);
						alphaBmd.copyChannel(newBmb,newBmb.rect,new Point(),BitmapDataChannel.ALPHA,BitmapDataChannel.BLUE);
						var alphaData:ByteArray = alphaQuality == 100 ? PNGEncoder.encode(alphaBmd) :  new JPGEncoder(alphaQuality).encode(alphaBmd);
						alphaBmd.dispose();
						
						bytes.writeUnsignedInt(alphaData.length);
						bytes.writeBytes(alphaData);
					}
					else
					{
						bytes.writeUnsignedInt(0);
					}
				}
				
				newBmb.dispose();
			}
			bytes.compress();
		}
	}
}