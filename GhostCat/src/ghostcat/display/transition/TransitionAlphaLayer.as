package ghostcat.display.transition
{
	import flash.display.Shape;
	
	import ghostcat.util.core.Handler;

	/**
	 * 白屏渐变过渡
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TransitionAlphaLayer extends TransitionObjectLayer
	{
		public function TransitionAlphaLayer(switchHandler:Handler,width:Number,height:Number,color:uint = 0xFFFFFF,fadeIn:int = 1000,fadeOut:int = 1000, wait:Boolean=false,easeIn:Function = null, easeOut:Function = null)
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill(color);
			shape.graphics.drawRect(0,0,width,height);
			shape.graphics.endFill();
			
			super(switchHandler,shape,null,fadeIn,fadeOut,wait,easeIn,easeOut);
		}
	}
}