package ghostcat.display.transfer
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
	import ghostcat.display.GBase;
	import ghostcat.events.TickEvent;
	import ghostcat.util.display.BitmapUtil;

	public class Boob extends GBase
	{
		private var quality:int;
		private var bitmaps:Array;
		private var bitmapData:BitmapData;
		
		public function Boob(source:Bitmap,rect:Rectangle,quality:int = 5)
		{
			super();
			
			this.bitmapData = BitmapUtil.clip(source.bitmapData,rect,false)
			this.quality = quality;
			this.x = rect.x;
			this.y = rect.y;
			
			render();
			
			this.enabledTick = true;
		}
		
		private function render() : void
		{
			removeBitmaps();
			var mx:Number = bitmapData.width / 2;
			var my:Number = bitmapData.height / 2;
			for (var i:int = quality;i >= 1;i--)
			{
				var w:Number = bitmapData.width / quality * i;
				var h:Number = bitmapData.height / quality * i;
				var img:Bitmap = new Bitmap(bitmapData)
				addChild(img);
				var mask:Shape = new Shape();
				mask.graphics.beginFill(0);
				mask.graphics.drawEllipse(mx - w/2,my - w/2,w,h);
				mask.graphics.endFill();
				addChild(mask);
				
				img.mask = mask;
				bitmaps.push(img);
			}
		}
		
		protected override function tickHandler(event:TickEvent):void
		{
			super.tickHandler(event);
			for (var i:int = 0; i < bitmaps.length;i++)
			{
				
			}
		}
		
		private function removeBitmaps():void
		{
			if (bitmaps)
			{
				for (var i:int = 0;i < bitmaps.length;i++)
				{
					var img:Bitmap = bitmaps[i] as Bitmap;
					img.parent.removeChild(img.mask);
					img.parent.removeChild(img);
				}
			}
			bitmaps = [];
		}
		
		public override function destory() : void
		{
			removeBitmaps();
			super.destory();
		}
	}
}