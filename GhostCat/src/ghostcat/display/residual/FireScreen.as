package ghostcat.display.residual
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObject;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.getTimer;

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
			super(width,height);
			
			maskBitmapData = new BitmapData(width,height);
			
			this.refreshInterval = 33;
			this.fadeSpeed = 0.9;
			this.blurSpeed = 4;
			this.offest = new Point(0,-4);
			
			displacementMapFilter = new DisplacementMapFilter(maskBitmapData,new Point(),BitmapDataChannel.RED,BitmapDataChannel.GREEN,9,9,DisplacementMapFilterMode.IGNORE);
		}
		
		protected override function updateSize():void
		{
			super.updateSize();
			
			if (!enabledScale)
			{
				var newBitmapData:BitmapData = new BitmapData(width,height);
				if (maskBitmapData)
				{
					newBitmapData.copyPixels(maskBitmapData,maskBitmapData.rect,new Point());
					maskBitmapData.dispose();
				}
				maskBitmapData = newBitmapData;
			}
		}
		
		protected override function updateDisplayList() : void
		{
			super.updateDisplayList();
			
			maskBitmapData.perlinNoise(16, 16, 1, getTimer(), false, true, BitmapDataChannel.RED | BitmapDataChannel.GREEN, false, [offest])
			bitmapData.applyFilter(bitmapData,bitmapData.rect,new Point(),displacementMapFilter);
		}
		
		protected override function drawItem(obj:DisplayObject):void
		{
			bitmapData.draw(obj,obj.transform.matrix,new ColorTransform(0,0,0,1,255));
		} 
		
		public override function destory() : void
		{
			super.destory();
			
			if (maskBitmapData)
				maskBitmapData.dispose()
		}
	}
}