package ghostcat.display.transition
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import ghostcat.operation.DelayOper;
	import ghostcat.operation.Oper;
	import ghostcat.operation.TweenOper;
	import ghostcat.util.core.Handler;

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
		
		public function TransitionDisplayLayer(switchHandler:Handler,displayObj:DisplayObject,fadeIn:int = 1000,fadeOut:int = 1000, wait:Boolean=false, easeIn:Function = null, easeOut:Function = null)
		{
			this.displayObj = displayObj;
			displayObj.alpha = 0.0;
			
			var fadeInOper:Oper;
			var fadeOutOper:Oper;
			var waitOper:Oper;
			
			if (fadeIn)
				fadeInOper = new TweenOper(displayObj,fadeIn,{autoAlpha:1.0,ease:easeIn});
			if (fadeOut)
				fadeOutOper = new TweenOper(displayObj,fadeOut,{autoAlpha:0,ease:easeOut});
			if (wait)
				waitOper = new DelayOper(-1);
			
			super(switchHandler,fadeInOper,fadeOutOper,waitOper);
		}
	}
}