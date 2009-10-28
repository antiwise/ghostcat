package ghostcat.display.transfer.effect
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	import ghostcat.util.core.Handler;

	/**
	 * 马赛克 
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class MosaicHandler extends Handler
	{
		public function MosaicHandler():void
		{
			super();
		}
		
		/** @inheritDoc*/
		public override function call(...params) : *
		{
			var normalBitmapData:BitmapData = params[0];
			var bitmapData:BitmapData = params[1];
			var deep:Number = params[2];
			
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
			
			var temp:BitmapData = new BitmapData(Math.ceil(source.width / size),Math.ceil(source.height / size),source.transparent,0);
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