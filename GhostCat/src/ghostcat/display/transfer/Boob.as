package ghostcat.display.transfer
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.algorithm.bezier.Roupe;
	import ghostcat.community.physics.RoupeLink;
	import ghostcat.display.GBase;
	import ghostcat.events.TickEvent;
	import ghostcat.util.display.BitmapUtil;

	public class Boob extends GBase
	{
		private var quality:int;
		private var items:Array;
		private var bitmapData:BitmapData;
		
		private var roupe:RoupeLink;
		
		public function Boob(source:Bitmap,rect:Rectangle,quality:int = 5)
		{
			super();
			
			this.bitmapData = BitmapUtil.clip(source.bitmapData,rect,false)
			this.quality = quality;
			this.x = rect.x;
			this.y = rect.y;
			
			render();
			this.roupe = new RoupeLink(0.3,0.85,null,true);
			this.roupe.addAll(items);
			
			this.enabledTick = true;
			
			addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			for (var i:int = 0;i < items.length;i++)
			{
				items[i].x = 0;
				items[i].y = 0;
			}
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
				var mask:Shape = new Shape();
				mask.graphics.beginFill(0);
				mask.graphics.drawEllipse(mx - w/2,my - w/2,w,h);
				mask.graphics.endFill();
				
				img.mask = mask;
				var item:Sprite = new Sprite();
				item.addChild(img);
				item.addChild(mask);
				addChild(item);
				
				items.push(item);
			}
		}
		
		protected override function tickHandler(event:TickEvent):void
		{
			super.tickHandler(event);
			roupe.tick(event.interval);
		}
		
		private function removeBitmaps():void
		{
			if (items)
			{
				for (var i:int = 0;i < items.length;i++)
				{
					var item:Sprite = items[i];
					removeChild(item);
				}
			}
			items = [];
		}
		
		public override function destory() : void
		{
			removeBitmaps();
			removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			super.destory();
		}
	}
}