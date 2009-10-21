package ghostcat.display.transition
{
	import flash.display.Shape;

	/**
	 * 白屏渐变过渡
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TransitionAlphaLayer extends TransitionDisplayLayer
	{
		public function TransitionAlphaLayer(switchHandler:Function,width:Number,height:Number,color:uint = 0xFFFFFF,fadeIn:String = null,fadeInDuration:int = 1000,fadeOut:String = null,fadeOutDuration:int = 1000, wait:Boolean=false)
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill(color);
			shape.graphics.drawRect(0,0,width,height);
			shape.graphics.endFill();
			
			super(switchHandler,shape,fadeIn,fadeInDuration,fadeOut,fadeOutDuration,wait);
		}
	}
}