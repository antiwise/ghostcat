package ghostcat.display.transfer.effect
{
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	
	import ghostcat.util.core.Handler;

	/**
	 * 用一个遮片图形的灰度来控制透明度变化
	 * @author flashyiyi
	 * 
	 */
	public class ThresholdMaskHandler extends Handler
	{
		public var mask:BitmapData;
	
		public function ThresholdMaskHandler(mask:BitmapData)
		{
			this.mask = mask;
		}
		
		public override function call(...params):*
		{
			var normalBitmapData:BitmapData = params[0];
			var bitmapData:BitmapData = params[1];
			var deep:Number = params[2];
			
			var bmd:BitmapData = new BitmapData(mask.width,mask.height,true,0);
			bmd.copyPixels(mask,mask.rect,new Point());
			bmd.applyFilter(bmd,bmd.rect,new Point(),new ColorMatrixFilter([
				1,0,0,0,0,
				0,1,0,0,0,
				0,0,1,0,0,
				1/3,1/3,1/3,0,255 * deep * 2 - 255
			]));
			bitmapData.copyPixels(normalBitmapData,normalBitmapData.rect,new Point(),bmd,new Point());
			bmd.dispose();
		}
	}
}