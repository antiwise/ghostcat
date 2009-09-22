package ghostcat.ui.containers
{
	import flash.geom.Rectangle;
	
	import ghostcat.display.GBase;
	import ghostcat.events.OperationEvent;
	import ghostcat.operation.effect.TweenEffect;
	import ghostcat.util.Geom;
	import ghostcat.util.TweenUtil;
	
	/**
	 * 采用Effect的Panel
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GEffectPanel extends GBase
	{
		public var createEffect:TweenEffect;
		public var showEffect:TweenEffect;
		public var closeEffect:TweenEffect;
		public var hideEffect:TweenEffect;
	
		/**
		 * 是否将注册点移动到屏幕中央
		 */
		public var centerLayout:Boolean = true;
		
		public function GEffectPanel(mc:*=null, replace:Boolean=true, centerLayout:Boolean = true)
		{
			this.centerLayout = centerLayout;
			
			super(mc, replace);
		}
		
		protected override function init():void
		{	
			super.init();
			
			if (createEffect)
			{
				TweenUtil.removeTween(createEffect.target);
				
				createEffect.invert = true;
				createEffect.execute();
			}
			
			if (centerLayout)
			{
				var pRect:Rectangle = Geom.getRect(parent,parent);
				this.x = pRect.x + pRect.width / 2;
				this.y = pRect.y + pRect.height / 2;
			}
		}
		
		public override function set visible(v:Boolean):void
		{
			if (super.visible == v)
				return;
			
			if (v)
			{
				super.visible = true;
				if (showEffect)
				{
					TweenUtil.removeTween(showEffect.target);
					
					showEffect.invert = true;
					showEffect.execute();
				}
			}
			else
			{
				if (hideEffect)
				{
					TweenUtil.removeTween(hideEffect.target);
					
					hideEffect.addEventListener(OperationEvent.OPERATION_COMPLETE,hideMovieEndHandler);
					hideEffect.execute();
				}
				else
					super.visible = false;
			}
		}
		
		public function close() : void
		{
			if (closeEffect)
			{
				TweenUtil.removeTween(closeEffect.target);
				
				closeEffect.addEventListener(OperationEvent.OPERATION_COMPLETE,closeMovieEndHandler);
				closeEffect.execute();
			}
			else
				destory();
		}
		
		private function closeMovieEndHandler(event:OperationEvent):void
		{
			if (closeEffect)
				closeEffect.removeEventListener(OperationEvent.OPERATION_COMPLETE,closeMovieEndHandler);
			
			destory();
		}
		
		private function hideMovieEndHandler(event:OperationEvent):void
		{
			if (hideEffect)
				hideEffect.removeEventListener(OperationEvent.OPERATION_COMPLETE,hideMovieEndHandler);
			
			super.visible = false;
		}
	}
}