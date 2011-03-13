package ghostcat.game.item
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import ghostcat.display.bitmap.IBitmapDataDrawer;
	import ghostcat.game.item.sort.ISortCalculater;
	import ghostcat.game.item.sort.SortYCalculater;

	public class BitmapGameItem extends Bitmap implements IGameItem,IBitmapDataDrawer
	{
		public var sortCalculater:ISortCalculater;
		
		public override function set x(v:Number):void
		{	
			if (x == v)
				return;
			
			super.x = v;
			
			if (sortCalculater)
				sortCalculater.calculate();
		}
		
		public override function set y(v:Number):void
		{
			if (y == v)
				return;
			
			super.y = v;
			
			if (sortCalculater)
				sortCalculater.calculate();
		}
		
		private var _priority:Number;
		
		public function get priority():Number
		{
			return _priority;
		}
		
		public function set priority(v:Number):void
		{
			_priority = v;
		}
		
		public function BitmapGameItem(bitmapData:BitmapData) 
		{
			super(bitmapData);	
		}
		
		/** @inheritDoc*/
		public function drawToBitmapData(target:BitmapData,offest:Point):void
		{
			if (bitmapData)
				target.copyPixels(bitmapData,bitmapData.rect,new Point(x + offest.x,y + offest.y),null,null,true);
		}		
		
		/** @inheritDoc*/
		public function getBitmapUnderMouse(mouseX:Number,mouseY:Number):Array
		{
			return (uint(bitmapData.getPixel32(mouseX - x,mouseY - y) >> 24) > 0) ? [this] : null;
		}
	}
}