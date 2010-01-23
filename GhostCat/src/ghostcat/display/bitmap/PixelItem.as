package ghostcat.display.bitmap
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.events.EventDispatcher;
	import flash.geom.Point;

	/**
	 * 像素对象
	 * @author flashyiyi
	 * 
	 */
	public class PixelItem extends EventDispatcher implements IBitmapDataDrawer
	{
		public var x:Number;
		public var y:Number;
		public var color:uint; 
		
		public function PixelItem(x:Number,y:Number,color:uint)
		{
			this.x = x;
			this.y = y;
			this.color = color;
		}
		
		/** @inheritDoc*/
		public function drawToBitmapData(bitmapData:BitmapData,offest:Point):void
		{
			bitmapData.setPixel32(x + offest.x,y + offest.y,color);
		}
		
		/** @inheritDoc*/
		public function drawToShape(target:Graphics,offest:Point):void
		{
			target.beginFill(color & 0xFFFFFF,uint(color >> 24)/0xFF);
			target.drawRect(int(x + offest.x),int(y + offest.y),1,1);
			target.endFill();
		}
		
		/** @inheritDoc*/
		public function getBitmapUnderMouse(mouseX:Number,mouseY:Number):Array
		{
			return (Math.round(mouseX) == Math.round(x) && Math.round(mouseY) - Math.round(y)) ? [this] : null;
		}
	}
}