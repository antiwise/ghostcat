package ghostcat.display.residual
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import ghostcat.debug.FPS;
	import ghostcat.display.bitmap.PerlinNoiseCacher;

	/**
	 * 火焰效果
	 * @author flashyiyi
	 * 
	 */
	public class FireScreen extends ResidualScreen
	{
		private var maskBitmapData:BitmapData;
		private var maskBitmapDatas:Array;
		private var maskIndex:int = 0;
		private var cacher:PerlinNoiseCacher;
		private var cacheNumber:int;
		
		private var displacementMapFilter:DisplacementMapFilter;
		
		public function FireScreen(width:Number,height:Number,cacheNumber:int = 20)
		{
			super(width,height);
			
			this.fadeSpeed = 0.9;
			this.blurSpeed = 4;
			this.offest = new Point(0,-4);
			this.cacheNumber = cacheNumber;
			this.itemColorTransform = new ColorTransform(0,0,0,1,255);
			
			this.maskBitmapData = new BitmapData(width,height);
			this.displacementMapFilter = createDisplacementMapFilter(maskBitmapData);
			
			if (cacheNumber)
				createCacher();
		}
		
		/** @inheritDoc*/
		protected override function updateSize():void
		{
			super.updateSize();
		
			if (maskBitmapData)
				maskBitmapData.dispose();
			
			this.maskBitmapData = new BitmapData(width,height);
			this.displacementMapFilter = createDisplacementMapFilter(maskBitmapData);
		
			if (cacher)
				cacher.destory();
			
			if (cacheNumber)
				createCacher();
		}
		
		private function createDisplacementMapFilter(maskBitmapData:BitmapData):DisplacementMapFilter
		{
			return new DisplacementMapFilter(maskBitmapData,new Point(),BitmapDataChannel.RED,BitmapDataChannel.GREEN,9,9,DisplacementMapFilterMode.IGNORE);
		}
		
		private function createCacher():void
		{
			cacher = new PerlinNoiseCacher(width,height,cacheNumber);
			cacher.create(16, 16, 1, getTimer(), false, true, BitmapDataChannel.RED | BitmapDataChannel.GREEN);
		}
		
		/** @inheritDoc*/
		protected override function updateDisplayList() : void
		{
			super.updateDisplayList();
			
			var bitmapData:BitmapData = (content as Bitmap).bitmapData;
			var t:int = Math.random() * 100;
			
			if (cacher)
				cacher.parse(maskBitmapData,t);
			else	
				maskBitmapData.perlinNoise(16, 16, 1, t, false, true, BitmapDataChannel.RED | BitmapDataChannel.GREEN);
			
			bitmapData.applyFilter(bitmapData,bitmapData.rect,new Point(),displacementMapFilter);
		}
		
		/** @inheritDoc*/
		public override function destory() : void
		{
			super.destory();
			
			if (cacher)
				cacher.destory();
			
			if (maskBitmapData)
				maskBitmapData.dispose()
		}
	}
}