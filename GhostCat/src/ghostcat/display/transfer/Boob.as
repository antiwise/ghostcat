package ghostcat.display.transfer
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import ghostcat.community.physics.RoupeLink;
	import ghostcat.events.TickEvent;
	import ghostcat.util.display.BitmapUtil;

	/**
	 * 乳摇效果 
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class Boob extends GTransfer
	{
		private var quality:int;
		private var items:Array;
		
		private var roupe:RoupeLink;
		
		private var boobBitmap:BitmapData;
		private var boobRect:Rectangle;
		
		public function Boob(source:Bitmap,rect:Rectangle,quality:int = 5)
		{
			super(source);
			
			this.quality = quality;
			this.x = rect.x;
			this.y = rect.y;
			this.boobRect = rect;
			
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
		/** @inheritDoc*/
		protected override function renderTarget() : void
		{
			var rect: Rectangle = _target.getBounds(_target);
			var m:Matrix = new Matrix();
			m.translate(-rect.x, -rect.y);
			bitmapData.fillRect(bitmapData.rect,0);
			bitmapData.draw(_target,m);
			this.boobBitmap = BitmapUtil.clip(bitmapData,this.boobRect,false)
					
			showBitmapData();
		}
		/** @inheritDoc*/
		protected override function showBitmapData() : void
		{
			removeBitmaps();
			var mx:Number = boobBitmap.width / 2;
			var my:Number = boobBitmap.height / 2;
			for (var i:int = quality;i >= 1;i--)
			{
				var w:Number = boobBitmap.width / quality * i;
				var h:Number = boobBitmap.height / quality * i;
				var img:Bitmap = new Bitmap(boobBitmap)
				var mask:Shape = new Shape();
				mask.graphics.beginFill(0);
				mask.graphics.drawEllipse(mx - w/2,my - w/2,w,h);
				mask.graphics.endFill();
				
				img.mask = mask;
				var item:Sprite = new Sprite();
				item.addChild(img);
				item.addChild(mask);
				img.y = mask.y = -(quality - i) * 10;
				
				addChild(item);
				
				items.push(item);
			}
		
			this.roupe = new RoupeLink(0.3,0.85,null,true);
			this.roupe.addAll(items);
			this.roupe.enabledTick = true;
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
		/** @inheritDoc*/
		public override function destory() : void
		{
			removeBitmaps();
			boobBitmap.dispose();
			removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			roupe.enabledTick = false;
			super.destory();
		}
	}
}