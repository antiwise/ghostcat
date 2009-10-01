package ghostcat.transfer
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 扫光效果
	 * @author flashyiyi
	 * 
	 */
	public class LightSweep extends GTransfer
	{
		private var _maxScale:Number = 1.2;
		private var _offest:Point = new Point();
		private var _quality:int = 10;
		
		private var bitmaps:Array;
		
		public function LightSweep(target:DisplayObject)
		{
			super(target);
		}
		
		public function get quality():int
		{
			return _quality;
		}

		public function set quality(v:int):void
		{
			_quality = v;
			render();
		}

		public function get offest():Point
		{
			return _offest;
		}

		public function set offest(v:Point):void
		{
			_offest = v;
			invalidateRenderBitmap();
		}

		public function get maxScale():Number
		{
			return _maxScale;
		}

		public function set maxScale(v:Number):void
		{
			_maxScale = v;
			invalidateRenderBitmap();
		}
		/** @inheritDoc*/
		protected override function render() : void
		{
			super.render();
			removeBitmaps();
			for (var i:int = 0;i < _quality;i++)
			{
				var img:Bitmap = new Bitmap(bitmapData);
				addChild(img);
				bitmaps.push(img);
			}
			
			renderBitmap();
		}

		/** @inheritDoc*/
		protected override function renderBitmap() : void
		{
			if (!bitmaps)
				return;
				
			var rect: Rectangle = _target.getBounds(_target);
			
			for (var i:int = 0;i < bitmaps.length;i++)
			{
				var img:Bitmap = bitmaps[i] as Bitmap;
				img.scaleX = img.scaleY = 1 + (maxScale - 1) * i / quality;
				img.alpha = 1 - i / quality;
				img.x = rect.x + offest.x * i / quality + (img.width / img.scaleX - img.width)/2;
				img.y = rect.y + offest.y * i / quality + (img.height / img.scaleY - img.height)/2;
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