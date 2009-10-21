package ghostcat.display.transition
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import ghostcat.operation.DelayOper;
	import ghostcat.operation.Oper;
	import ghostcat.operation.TweenOper;

	/**
	 * 显示一个过渡对象的透明渐变过渡
	 * 
	 * 当设置了wait属性后，将会暂停，此时只能用continueFadeOut方法继续
	 *
	 * @author flashyiyi
	 * 
	 */
	public class TransitionDisplayLayer extends TransitionLayer
	{
		/**
		 * 遮挡对象
		 */
		public var displayObj:DisplayObject;
		
		/** @inheritDoc*/
		public override function createTo(container:DisplayObjectContainer):TransitionLayer
		{
			container.addChild(displayObj);
			return super.createTo(container);
		}
		
		public function TransitionDisplayLayer(switchHandler:Function,displayObj:DisplayObject,fadeIn:String = null,fadeInDuration:int = 1000,fadeOut:String = null,fadeOutDuration:int = 1000, wait:Boolean=false)
		{
			this.displayObj = displayObj;
			displayObj.alpha = 0.0;
			
			var fadeInOper:Oper;
			var fadeOutOper:Oper;
			var waitOper:Oper;
			
			if (fadeIn)
				fadeInOper = new TweenOper(displayObj,fadeInDuration,{autoAlpha:1.0});
			if (fadeOut)
				fadeOutOper = new TweenOper(displayObj,fadeOutDuration,{autoAlpha:0});
			if (wait)
				waitOper = new DelayOper(-1);
			
			super(switchHandler,fadeInOper,fadeOutOper,waitOper);
		}
	}
}