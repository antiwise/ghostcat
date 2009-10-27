package ghostcat.display.transition
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import ghostcat.display.IGBase;
	import ghostcat.events.GEvent;
	import ghostcat.operation.DelayOper;
	import ghostcat.operation.Oper;
	import ghostcat.operation.TweenOper;
	import ghostcat.parse.display.DrawParse;
	import ghostcat.util.core.Handler;
	
	/**
	 * 过渡会先进行缓存，然后对缓存进行Tween
	 * 
	 * 当设置了wait属性后，将会暂停，此时只能用continueFadeOut方法继续
	 *
	 * @author flashyiyi
	 * 
	 */
	public class TransitionCacheLayer extends TransitionLayerBase
	{
		/**
		 * 遮挡对象
		 */
		public var transfer:Bitmap;
		
		/** @inheritDoc*/
		public override function createTo(container:DisplayObjectContainer):TransitionLayerBase
		{
			container.addChild(transfer);
			return super.createTo(container);
		}
			
		public function TransitionCacheLayer(switchHandler:*,target:DisplayObject,duration:int = 1000, tweenParams:Object = null, wait:Boolean=false)
		{
			this.transfer = new DrawParse(target).createBitmap();
			transfer.alpha = 1.0;
			
			if (!tweenParams)
				tweenParams = {alpha:0.0};
			
			var fadeOutOper:Oper;
			var waitOper:Oper;
			
			if (duration)
				fadeOutOper = new TweenOper(transfer,duration,tweenParams);
			if (wait)
				waitOper = new DelayOper(-1);
			
			super(switchHandler,null,fadeOutOper,waitOper);
		}
		
		/** @inheritDoc*/
		public override function destory() : void
		{
			transfer.parent.removeChild(transfer);
			transfer.bitmapData.dispose();
			
			super.destory();
		}
	}
}