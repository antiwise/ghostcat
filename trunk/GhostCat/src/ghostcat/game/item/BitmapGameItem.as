package ghostcat.game.item
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import ghostcat.display.bitmap.IBitmapDataDrawer;

	public class BitmapGameItem extends Bitmap implements IGameItem,IBitmapDataDrawer
	{
		public function BitmapGameItem(bitmapData:BitmapData) 
		{
			super(bitmapData);	
		}
		
		/** @inheritDoc*/
		public function drawToBitmapData(target:BitmapData,offest:Point):void
		{
			if (bitmapData)
				target.copyPixels(bitmapData,bitmapData.rect,new Point(x + offest.x,y + offest.y));
		}		
		
		/** @inheritDoc*/
		public function getBitmapUnderMouse(mouseX:Number,mouseY:Number):Array
		{
			return (uint(bitmapData.getPixel32(mouseX - x,mouseY - y) >> 24) > 0) ? [this] : null;
		}
	}
}