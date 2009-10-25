package ghostcat.transfer
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;

	/**
	 * 马赛克变化类
	 *  
	 * @author flashyiyi
	 * 
	 */
	public class MosaicTransfer extends GBitmapCacheTransfer
	{
		public function MosaicTransfer(target:DisplayObject=null)
		{
			this.command = renderMosaic;
			super(target);
		}
		
		private function renderMosaic(normalBitmapData:BitmapData) : void
		{
			var v:int = normalBitmapData.width * deep / 4;
			mosaic(normalBitmapData,bitmapData,v);
		}
		
		/**
		 * 马赛克
		 * 
		 * @param source
		 * @param result
		 * @param scaleX
		 * @param scaleY
		 * @return 
		 * 
		 */
		public static function mosaic(source:BitmapData,result:BitmapData=null,size:int = 1):BitmapData
		{
			if (size < 1)
				size = 1;
			
			if (!result)
				result = new BitmapData(source.width,source.height,source.transparent,0);
			
			result.fillRect(result.rect,0);
			
			var temp:BitmapData = new BitmapData(source.width / size,source.height / size,source.transparent,0);
			var m:Matrix;
			m = new Matrix();
			m.scale(1/size,1/size);
			temp.draw(source,m);
			
			m = new Matrix();
			m.scale(size,size);
			result.draw(temp,m);
			
			temp.dispose();
			return result;
		}
	}
}
