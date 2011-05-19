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
		public var center:Boolean = false;
		public function MosaicHandler(center:Boolean = false):void
		{
			super();
			this.center = center;
		}
		
		/** @inheritDoc*/
		public override function call(...params) : *
		{
			var normalBitmapData:BitmapData = params[0];
			var bitmapData:BitmapData = params[1];
			var deep:Number = params[2];
			
			if (deep == 0)
				deep = 0.01;
			
			var v:int = normalBitmapData.width * deep / 5;
			mosaic(normalBitmapData,bitmapData,v,center);
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
		public static function mosaic(source:BitmapData,result:BitmapData=null,size:int = 1,center:Boolean = false):BitmapData
		{
			if (size < 1)
				size = 1;
			
			if (!result)
				result = new BitmapData(source.width,source.height,source.transparent,0);
			
			result.fillRect(result.rect,0);
			
			var temp:BitmapData = source.clone();
			var m:Matrix;
			m = new Matrix();
			if (center) m.translate(-source.width / 2,-source.height / 2);
			m.scale(1/size,1/size);
			if (center) m.translate(source.width / 2,source.height / 2);
			temp.draw(source,m);
			
			m.invert();
			result.draw(temp,m);
			
			temp.dispose();
			return result;
		}
	}
}