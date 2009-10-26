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
	import ghostcat.util.core.Handler;

	/**
	 * 过渡过程会先渐变到一个过渡对象，然后再进入另一个结果状态
	 * 
	 * 当设置了wait属性后，将会暂停，此时只能用continueFadeOut方法继续
	 *
	 * @author flashyiyi
	 * 
	 */
	public class TransitionObjectLayer extends TransitionLayerBase
	{
		/**
		 * 遮挡对象
		 */
		public var transfer:DisplayObject;
		
		/**
		 * 遮挡目标
		 */
		public var hideObject:DisplayObject;
		
		/** @inheritDoc*/
		public override function createTo(container:DisplayObjectContainer):TransitionLayerBase
		{
			container.addChild(transfer);
			return super.createTo(container);
		}
		
		/** @inheritDoc*/
		public override function set state(v:String):void
		{
			if (state == v)
				return;
			
			if (hideObject)
			{
				switch (v)
				{
					case FADE_IN:
						hideObject.visible = false;
						break;
					case FADE_OUT:
						hideObject.dispatchEvent(new GEvent(GEvent.UPDATE_COMPLETE))
						break;
					case END:
						hideObject.visible = true;
						break;
				}
			}
			super.state = v;
		}
		
		/**
		 * 
		 * @param switchHandler	变化方法
		 * @param transfer	遮挡对象
		 * @param target	被遮挡的目标
		 * @param fadeIn	显示持续时间
		 * @param fadeOut	消失持续时间
		 * @param wait	是否等待
		 * @param easeIn	显示缓动
		 * @param easeOut	消失缓动
		 * 
		 */
		public function TransitionObjectLayer(switchHandler:*,transfer:DisplayObject,hideObject:DisplayObject = null,fadeIn:int = 1000,fadeOut:int = 1000, wait:Boolean=false, easeIn:Function = null, easeOut:Function = null)
		{
			this.transfer = transfer;
			this.hideObject = hideObject;
			transfer.alpha = 0.0;
			
			var fadeInOper:Oper;
			var fadeOutOper:Oper;
			var waitOper:Oper;
			
			if (fadeIn)
				fadeInOper = new TweenOper(transfer,fadeIn,{alpha:1.0,ease:easeIn});
			if (fadeOut)
				fadeOutOper = new TweenOper(transfer,fadeOut,{alpha:0.0,ease:easeOut});
			if (wait)
				waitOper = new DelayOper(-1);
			
			super(switchHandler,fadeInOper,fadeOutOper,waitOper);
		}
		
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (transfer is IGBase)
			{
				(transfer as IGBase).destory();
			}
			else if (transfer is DisplayObject)
			{
				transfer.parent.removeChild(transfer);
				if (transfer is Bitmap)
					(transfer as Bitmap).bitmapData.dispose();
			}
			super.destory();
		}
	}
}