package ghostcat.fileformat.pak
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import ghostcat.util.Util;
	
	public class PakDecoder extends EventDispatcher
	{
		public var bytes:ByteArray;
		
		public var result:Array;
		public var offests:Array;
		public var sizes:Array;
		public var length:int;
		
		public var type:int;
		public var quality:int;
		public var alphaQuality:int;
		
		private var loadList:Array;
		private var bmds:Array;
		public function PakDecoder(bytes:ByteArray)
		{
			this.bytes = bytes;
		}
		
		public function decode():void
		{
			var allData:ByteArray = new ByteArray();
			
			bytes.position = 0;
			bytes.readBytes(allData,0,bytes.length);
			allData.position = 0;
			allData.uncompress();
			
			type = allData.readByte();
			quality = allData.readByte();
			alphaQuality = allData.readByte();
			length = allData.readUnsignedShort();
			
			bmds = [];
			loadList = [];
			
			offests = [];
			sizes = [];
			if (type == 1)
			{
				for (var i:int = 0;i < length;i++)
				{
					var offX:int = allData.readShort();
					var offY:int = allData.readShort();
					var w:int = allData.readShort();
					var h:int = allData.readShort();
					offests.push(new Point(offX,offY));
					sizes.push(new Point(w,h));
				}
				readData(allData);
			}
			else if (type == 2)
			{
				for (i = 0;i < length;i++)
				{
					offX = allData.readShort();
					offY = allData.readShort();
					w = allData.readShort();
					h = allData.readShort();
					offests.push(new Point(offX,offY));
					sizes.push(new Point(w,h));
					readData(allData);
				}
			}
			
			loadNext();
		}
		
		private function readData(allData:ByteArray):void
		{
			var len:int = allData.readUnsignedInt();
			var data:ByteArray = new ByteArray();
			allData.readBytes(data,0,len);
			loadList.push(data);
			
			if (alphaQuality != 0 && quality != alphaQuality)
			{
				var alphaData:ByteArray = new ByteArray();
				len = allData.readUnsignedInt();
				if (len)
					allData.readBytes(alphaData,0,len);
				loadList.push(alphaData);
			}
		}
		
		private var loadNum:int;
		
		private function loadNext():void
		{
			loadNum = 0;
			
			for each (var data:ByteArray in loadList)
			{
				loadData(data);
			}
		}
		
		private function loadData(data:ByteArray):void
		{
			var loader:Loader = new Loader();
			loader.loadBytes(data);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadCompleteHandler);
			
			function loadCompleteHandler(e:Event):void
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadCompleteHandler);
				var index:int = loadList.indexOf(data);
				bmds[index] = (loader.content as Bitmap).bitmapData;
				
				loadNum++;
				
				if (loadNum >= loadList.length)
					loadAllComplete();
			}
		}
		
		private function loadAllComplete():void
		{
			result = [];
			if (type == 1)
			{
				var dx:int = 0;
				for (var i:int = 0; i < length;i++)
				{
					var size:Point = sizes[i];
					var newBmd:BitmapData = new BitmapData(size.x,size.y,true,0);
					var bmdRect:Rectangle = new Rectangle(dx,0,size.x,size.y);
					if (alphaQuality != 0 && quality != alphaQuality)
					{
						var bmd:BitmapData = bmds[0];
						var alphaBmd:BitmapData = bmds[1];
						newBmd.copyPixels(bmd,bmdRect,new Point());
						newBmd.copyChannel(alphaBmd,bmdRect,new Point(),BitmapDataChannel.RED,BitmapDataChannel.ALPHA);
					}
					else
					{
						bmd = bmds[0];
						newBmd.copyPixels(bmd,bmdRect,new Point());
						newBmd.copyChannel(bmd,new Rectangle(dx,bmd.height / 2,size.x,size.y),new Point(),BitmapDataChannel.RED,BitmapDataChannel.ALPHA);
					}
					
					result.push(newBmd);
					dx += size.x;
				}
				
				bmd.dispose();
				if (alphaBmd)
					alphaBmd.dispose();
			}
			else if (type == 2)
			{
				for (i = 0; i < length;i++)
				{
					size = sizes[i];
					newBmd = new BitmapData(size.x,size.y,true,0);
					bmdRect = new Rectangle(0,0,size.x,size.y);
					if (alphaQuality != 0 && quality != alphaQuality)
					{
						bmd = bmds[i * 2];
						alphaBmd = bmds[i * 2 + 1];
						newBmd.copyPixels(bmd,bmdRect,new Point());
						newBmd.copyChannel(alphaBmd,bmdRect,new Point(),BitmapDataChannel.RED,BitmapDataChannel.ALPHA);
						
						bmd.dispose();
						alphaBmd.dispose();
						
					}
					else
					{
						bmd = bmds[i];
						newBmd.copyPixels(bmd,bmdRect,new Point());
						newBmd.copyChannel(bmd,new Rectangle(0,size.y,size.x,size.y),new Point(),BitmapDataChannel.RED,BitmapDataChannel.ALPHA);
						
						bmd.dispose();
					}
					
					result.push(newBmd);
				}
			}
			
			bmds = null;
			loadList = null;
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function dispose():void
		{
			if (result)
			{
				for each (var bmd:BitmapData in this.result)
				bmd.dispose();	
			}
		}
	}
}