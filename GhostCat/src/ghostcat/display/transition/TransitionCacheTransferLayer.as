package ghostcat.display.transition
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	
	import ghostcat.operation.DelayOper;
	import ghostcat.operation.Oper;
	import ghostcat.operation.TweenOper;
	import ghostcat.transfer.GBitmapCacheTransfer;
	import ghostcat.util.core.Handler;

	/**
	 * 使用位图特效过渡（马赛克，溶解）来显示过渡效果
	 * 
	 * 当设置了wait属性后，将会暂停，此时只能用continueFadeOut方法继续
	 *
	 * @author flashyiyi
	 * 
	 */
	public class TransitionCacheTransferLayer extends TransitionLayer
	{
		/**
		 * 遮挡对象
		 */
		public var transfer:GBitmapCacheTransfer;
		
		/** @inheritDoc*/
		public override function createTo(container:DisplayObjectContainer):TransitionLayer
		{
			container.addChild(transfer);
			return super.createTo(container);
		}
		
		/** @inheritDoc*/
		public override function set state(v:String):void
		{
			if (state == v)
				return;
			
			switch (v)
			{
				case FADE_IN:
					transfer.target.visible = false;
					break;
				case FADE_OUT:
					transfer.render();
					break;
				case END:
					transfer.target.visible = true;
					break;
			}
			super.state = v;
		}
		
		public function TransitionCacheTransferLayer(switchHandler:Handler,displayObj:GBitmapCacheTransfer,fadeIn:int = 1000,fadeOut:int = 1000, wait:Boolean=false, easeIn:Function = null, easeOut:Function = null)
		{
			this.transfer = displayObj;
			displayObj.deep = 0.0;
			
			var fadeInOper:Oper;
			var fadeOutOper:Oper;
			var waitOper:Oper;
			
			if (fadeIn)
				fadeInOper = new TweenOper(displayObj,fadeIn,{deep:1.0,ease:easeIn});
			if (fadeOut)
				fadeOutOper = new TweenOper(displayObj,fadeOut,{deep:0.0,ease:easeOut});
			if (wait)
				waitOper = new DelayOper(-1);
			
			super(switchHandler,fadeInOper,fadeOutOper,waitOper);
		}
		
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (transfer)
				transfer.destory();
			
			super.destory();
		}
	}
}