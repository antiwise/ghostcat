package ghostcat.display.residual
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObject;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.ColorTransform;
	import flash.geom.Point;

	/**
	 * 摆动方式固定的火焰效果（速度稍快）
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class FireScreen2 extends ResidualScreen
	{
		/**
		 * 缓存次数
		 */
		public var cacheNumber:int = 10;
				
		private var maskBitmapDatas:Array;
		private var maskIndex:int = 0;
		
		private var displacementMapFilter:DisplacementMapFilter;
		
		public function FireScreen2(width:Number,height:Number)
		{
			super(width,height);
			
			this.enabledTick = true;
			this.fadeSpeed = 0.9;
			this.blurSpeed = 4;
			this.offest = new Point(0,-4);
			this.itemColorTransform = new ColorTransform(0,0,0,1,255);
			
			createMaskBitmapDatas();
		}
		
		private function createMaskBitmapDatas():void
		{
			destoryMaskBitmapDatas();
			
			maskBitmapDatas = [];
			for (var i:int = 0;i < cacheNumber;i++)
			{
				var maskBitmapData:BitmapData = new BitmapData(width,height);
				maskBitmapData.perlinNoise(16, 16, 1, i, false, true, BitmapDataChannel.RED | BitmapDataChannel.GREEN, false, [offest])
				maskBitmapDatas.push(maskBitmapData);
			}
		}
		
		private function destoryMaskBitmapDatas():void
		{
			if (!maskBitmapDatas)
				return;
			
			for (var i:int = 0;i < maskBitmapDatas.length;i++)
			{
				var maskBitmapData:BitmapData = maskBitmapData[i] as BitmapData;
				maskBitmapData.dispose();
			}
			maskBitmapDatas = null;
		}
		/** @inheritDoc*/
		protected override function updateSize():void
		{
			super.updateSize();
			
			createMaskBitmapDatas();
		}
		/** @inheritDoc*/
		protected override function updateDisplayList() : void
		{
			if (mode != MODE_BITMAP)
				return;
			
			var bitmapData:BitmapData = (content as Bitmap).bitmapData;
			super.updateDisplayList();
			
			maskIndex++;
			if (maskIndex >= 10)
				maskIndex = 0;
			
			displacementMapFilter = new DisplacementMapFilter(maskBitmapDatas[maskIndex],new Point(),BitmapDataChannel.RED,BitmapDataChannel.GREEN,9,9,DisplacementMapFilterMode.IGNORE);
			bitmapData.applyFilter(bitmapData,bitmapData.rect,new Point(),displacementMapFilter);
		}
		/** @inheritDoc*/
		public override function destory() : void
		{
			super.destory();
			
			destoryMaskBitmapDatas();
		}
	}
}