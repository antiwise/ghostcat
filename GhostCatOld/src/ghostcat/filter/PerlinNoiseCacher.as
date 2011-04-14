package ghostcat.filter
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.geom.Point;

	/**
	 * PerlinNoise缓存
	 * @author flashyiyi
	 * 
	 */
	public class PerlinNoiseCacher
	{
		public var width:int;
		public var height:int;
		public var cacheNumber:int;
		public var masks:Array;
		
		public static function getBitmapData(width:Number,height:Number, baseX:Number, baseY:Number, numOctaves:uint = 1, randomSeed:int = 0, stitch:Boolean = false, fractalNoise:Boolean = true, channelOptions:uint = 3, grayScale:Boolean = false, offsets:Array = null):BitmapData
		{
			var bmd:BitmapData = new BitmapData(width,height);
			bmd.perlinNoise(baseX, baseY, numOctaves, randomSeed, stitch, fractalNoise, channelOptions, grayScale,offsets);
			return bmd;
		}
		
		public function PerlinNoiseCacher(width:Number,height:Number,cacheNumber:int = 20)
		{
			this.width = width;
			this.height = height;
			this.cacheNumber = cacheNumber;
		}
		
		public function create(baseX:Number, baseY:Number, numOctaves:uint = 1, randomSeed:int = 0, stitch:Boolean = false, fractalNoise:Boolean = true, channelOptions:uint = 3, grayScale:Boolean = false, offsets:Array = null):void
		{
			if (masks)
				destory();
			
			this.masks = [];
			for (var i:int = 0;i < cacheNumber;i++)
			{
				var bmd:BitmapData = new BitmapData(width,height);
				bmd.perlinNoise(baseX, baseY, numOctaves, randomSeed + i, stitch, fractalNoise, channelOptions, grayScale,offsets);
				this.masks[this.masks.length] = bmd;
			}
		}
		
		public function getBitmapData(t:int):BitmapData
		{
			return masks[t % cacheNumber];
		}
		
		public function parse(bmd:BitmapData,t:int):void
		{
			var source:BitmapData = getBitmapData(t);
			bmd.copyPixels(getBitmapData(t),source.rect,new Point());
		}
		
		public function destory():void
		{
			if (!masks)
				return;
			
			for each (var mask:BitmapData in masks)
				mask.dispose();
			
			masks = null;
		}
	}
}