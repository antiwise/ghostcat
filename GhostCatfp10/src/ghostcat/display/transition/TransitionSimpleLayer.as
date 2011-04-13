package ghostcat.display.transition
{
	import flash.display.Shape;
	
	import ghostcat.util.core.Handler;

	/**
	 * 简单渐变过渡（白屏渐变，曝光渐变等）
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TransitionSimpleLayer extends TransitionObjectLayer
	{
		/**
		 *  
		 * @param switchHandler - 切换
		 * @param width - 长度
		 * @param height - 高度
		 * @param color - 颜色
		 * @param blendMode - 混合模式（例如：设置为add将会产生曝光渐变，设置为subtract会产生变暗渐变）
		 * @param fadeIn	进入时间
		 * @param fadeOut	退出时间
		 * @param wait	是否等待
		 * @param easeIn	进入缓动函数
		 * @param easeOut	退出缓动函数
		 * 
		 */
		public function TransitionSimpleLayer(switchHandler:*,width:Number,height:Number,color:uint = 0xFFFFFF,blendMode:String = "normal",fadeIn:int = 1000,fadeOut:int = 1000, wait:Boolean=false,easeIn:Function = null, easeOut:Function = null)
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill(color);
			shape.graphics.drawRect(0,0,width,height);
			shape.graphics.endFill();
			shape.blendMode = blendMode;
			
			super(switchHandler,shape,null,fadeIn,fadeOut,wait,easeIn,easeOut);
		}
	}
}