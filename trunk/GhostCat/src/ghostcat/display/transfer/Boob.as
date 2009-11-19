package ghostcat.display.transfer
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
			this.x = rect.x + rect.width / 2;
			this.y = rect.y + rect.height / 2;
			
			render();
			
			this.enabledTick = true;
		}
		
		private function render() : void
		{
			removeBitmaps();
			for (var i:int = quality - 1;i >= 1;i--)
			{
				var w:Number = bitmapData.width / quality * i;
				var h:Number = bitmapData.height / quality * i;
				var img:Bitmap = new Bitmap(BitmapUtil.clip(bitmapData,new Rectangle((bitmapData.width - w) / 2,(bitmapData.height - h) / 2,w,h),false))
				img.x = -img.width / 2;
				img.y = -img.height / 2;
				addChild(img);
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