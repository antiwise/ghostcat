package ghostcat.display.residual
{
	import flash.geom.ColorTransform;
	
	/**
	 * 动态模糊类
	 * @author flashyiyi
	 * 
	 */
	public class MotionBlurScreen extends ResidualScreen
	{
		public function MotionBlurScreen(width:Number,height:Number,layerNum:int = 3)
		{
			super(width,height,true);
			this.setLayerNum(layerNum);
		}
		
		public function setLayerNum(num:int):void
		{
			this.itemColorTransform = new ColorTransform(1,1,1,1 - 1 / num);
			this.fadeSpeed = 1 - 1 / num;
		}
		
	}
}