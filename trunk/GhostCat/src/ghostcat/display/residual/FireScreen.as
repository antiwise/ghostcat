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
		
		private var displacementMapFilter:DisplacementMapFilter;
		
		public function FireScreen(width:Number,height:Number,cacheNumber:int = 0)
		{
			super(width,height);
			
			this.maskBitmapData = new BitmapData(width,height);
			
			this.fadeSpeed = 0.9;
			this.blurSpeed = 4;
			this.offest = new Point(0,-4);
			this.itemColorTransform = new ColorTransform(0,0,0,1,255);
		
			this.displacementMapFilter = new DisplacementMapFilter(maskBitmapData,new Point(),BitmapDataChannel.RED,BitmapDataChannel.GREEN,9,9,DisplacementMapFilterMode.IGNORE);
		
			if (cacheNumber)
				createMaskBitmapDatas(cacheNumber);
		}
		
		/** @inheritDoc*/
		protected override function updateSize():void
		{
			super.updateSize();
		
			if (maskBitmapDatas)
			{
				createMaskBitmapDatas(maskBitmapDatas.length);
			}
			else
			{
				if (maskBitmapData)
					maskBitmapData.dispose();
			
				this.maskBitmapData = new BitmapData(width,height);
				this.displacementMapFilter = createDisplacementMapFilter(maskBitmapData);
			}
		}
		
		private function createDisplacementMapFilter(maskBitmapData:BitmapData):DisplacementMapFilter
		{
			return new DisplacementMapFilter(maskBitmapData,new Point(),BitmapDataChannel.RED,BitmapDataChannel.GREEN,9,9,DisplacementMapFilterMode.IGNORE);
		}
		
		private function createPerlinNoise(maskBitmapData:BitmapData,t:int):void
		{
			maskBitmapData.perlinNoise(16, 16, 1, t, false, true, BitmapDataChannel.RED | BitmapDataChannel.GREEN, false, [offest]);
		}
		
		/** @inheritDoc*/
		protected override function updateDisplayList() : void
		{
			super.updateDisplayList();
			
			var bitmapData:BitmapData = (content as Bitmap).bitmapData;
			if (maskBitmapDatas)
			{
				maskIndex++;
				if (maskIndex >= maskBitmapDatas.length)
					maskIndex = 0;
				
				this.displacementMapFilter = createDisplacementMapFilter(maskBitmapData);
				bitmapData.applyFilter(bitmapData,bitmapData.rect,new Point(),displacementMapFilter);
			}
			else
			{
				createPerlinNoise(this.maskBitmapData,getTimer());
				bitmapData.applyFilter(bitmapData,bitmapData.rect,new Point(),displacementMapFilter);
			}
		}
		
		public function createMaskBitmapDatas(cacheNumber:int):void
		{
			destoryMaskBitmapDatas();
			
			maskBitmapDatas = [];
			for (var i:int = 0;i < cacheNumber;i++)
			{
				var maskBitmapData:BitmapData = new BitmapData(width,height);
				createPerlinNoise(maskBitmapData,i);
				maskBitmapDatas.push(maskBitmapData);
			}
		}
		
		public function destoryMaskBitmapDatas():void
		{
			if (!maskBitmapDatas)
				return;
			
			for (var i:int = 0;i < maskBitmapDatas.length;i++)
			{
				var maskBitmapData:BitmapData = maskBitmapDatas[i] as BitmapData;
				maskBitmapData.dispose();
			}
			
			maskBitmapDatas = null;
		}
		
		/** @inheritDoc*/
		public override function destory() : void
		{
			super.destory();
			
			this.destoryMaskBitmapDatas();
			
			if (maskBitmapData)
				maskBitmapData.dispose()
		}
	}
}