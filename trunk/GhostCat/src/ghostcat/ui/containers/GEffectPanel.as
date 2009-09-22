package ghostcat.ui.containers
{
	import flash.geom.Rectangle;
	
	import ghostcat.display.GBase;
	import ghostcat.events.OperationEvent;
	import ghostcat.operation.Oper;
	import ghostcat.operation.Queue;
	import ghostcat.operation.TweenOper;
	import ghostcat.util.Geom;
	
	/**
	 * 采用Effect的Panel
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GEffectPanel extends GBase
	{
		public var createEffect:TweenOper;
		public var showEffect:TweenOper;
		public var closeEffect:TweenOper;
		public var hideEffect:TweenOper;
		
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
					showEffect.invert = true;
					showEffect.execute();
				}
			}
			else
			{
				if (hideEffect)
				{
					hideEffect.addEventListener(OperationEvent.OPERATION_COMPLETE,hideMovieEndHandler);
					hideEffect.execute();
				}
				else
					hideMovieEndHandler(null);
			}
		}
		
		public function close() : void
		{
			if (closeEffect)
			{
				closeEffect.addEventListener(OperationEvent.OPERATION_COMPLETE,closeMovieEndHandler);
				closeEffect.execute();
			}
			else
				closeMovieEndHandler(null);
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