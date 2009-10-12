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
		private var maskIndex:int = 0;
		
		private var displacementMapFilter:DisplacementMapFilter;
		
		public function FireScreen(width:Number,height:Number)
		{
			addChild(new FPS())
			
			super(width,height);
			
			maskBitmapData = new BitmapData(width,height);
			
			this.fadeSpeed = 0.9;
			this.blurSpeed = 4;
			this.offest = new Point(0,-4);
			this.itemColorTransform = new ColorTransform(0,0,0,1,255);
		
			displacementMapFilter = new DisplacementMapFilter(maskBitmapData,new Point(),BitmapDataChannel.RED,BitmapDataChannel.GREEN,9,9,DisplacementMapFilterMode.IGNORE);
		}
		/** @inheritDoc*/
		protected override function updateSize():void
		{
			if (mode != MODE_BITMAP)
				return;
			
			super.updateSize();
			
			var newBitmapData:BitmapData = new BitmapData(width,height);
			if (maskBitmapData)
			{
				newBitmapData.copyPixels(maskBitmapData,maskBitmapData.rect,new Point());
				maskBitmapData.dispose();
			}
			maskBitmapData = newBitmapData;
			displacementMapFilter = new DisplacementMapFilter(maskBitmapData,new Point(),BitmapDataChannel.RED,BitmapDataChannel.GREEN,9,9,DisplacementMapFilterMode.IGNORE);
		}
		/** @inheritDoc*/
		protected override function updateDisplayList() : void
		{
			super.updateDisplayList();
			
			maskBitmapData.perlinNoise(16, 16, 1, getTimer(), false, true, BitmapDataChannel.RED | BitmapDataChannel.GREEN, false, [offest])
			
			var bitmapData:BitmapData = (content as Bitmap).bitmapData;
			bitmapData.applyFilter(bitmapData,bitmapData.rect,new Point(),displacementMapFilter);
		}
		/** @inheritDoc*/
		public override function destory() : void
		{
			super.destory();
			
			if (maskBitmapData)
				maskBitmapData.dispose()
		}
	}
}