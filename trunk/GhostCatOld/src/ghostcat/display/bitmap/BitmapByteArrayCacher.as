package ghostcat.display.bitmap
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	/**
	 * 将位图缓存为ByteArray 
	 * @author flashyiyi
	 * 
	 */
	public class BitmapByteArrayCacher
	{
		public var byteArray:ByteArray;
		public var bitmapData:BitmapData;
		public function BitmapByteArrayCacher(bitmapData:BitmapData)
		{
			this.bitmapData = bitmapData;
			render();
		}
		
		public function render():void
		{
			byteArray = this.bitmapData.getPixels(this.bitmapData.rect);
		}
		
		public function drawToBitmapData(target:BitmapData,offest:Point):void
		{
			byteArray.position = 0;
			target.setPixels(new Rectangle(offest.x,offest.y,bitmapData.width,bitmapData.height),byteArray);
		}
	}
}