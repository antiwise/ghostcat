package ghostcat.display.transfer.effect
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import ghostcat.util.core.Handler;

	/**
	 * 用一个遮片图形的红色通道来控制是否显示像素
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
			bmd.threshold(mask,mask.rect,new Point(),">",deep * 0xFF,0,0xFF,true);
			bitmapData.fillRect(bitmapData.rect,0);
			bitmapData.copyPixels(normalBitmapData,normalBitmapData.rect,new Point(),bmd,new Point());
			
			bmd.dispose();
		}
	}
}