package ghostcat.transfer
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import ghostcat.display.GNoScale;
	import ghostcat.events.GEvent;
	import ghostcat.events.MoveEvent;
	import ghostcat.events.ResizeEvent;
	import ghostcat.util.core.UniqueCall;

	
	/**
	 * 用于实时将显示对象转换为位图处理的类
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GTransfer extends GNoScale
	{
		protected var _target:DisplayObject;
		
		protected var bitmapData:BitmapData;
		
		protected var renderBitmapCall:UniqueCall = new UniqueCall(renderBitmap);
		
		public function GTransfer(target:DisplayObject=null):void
		{
			super();
			
			if (target)
				this.target = target;
		}
                
		/**
		 * 设置目标
		 * @return 
		 * 
		 */
		public function get target(): DisplayObject
		{
			return _target;
		}

		public function set target(value: DisplayObject): void
		{
			removeTargetEvents();
			_target = value;
			addTargetEvents();
			
			updateTargetMove();
			createBitmapData();
			invalidateDisplayList();
		}
		                
		/**
		 * 更新目标位置
		 * 
		 */
		public function updateTargetMove():void
		{
			x = _target.x;
			y = _target.y;
		}
		
		/**
		 * 更新目标大小
		 * 
		 */
		public function updateTargetResize():void
		{
			createBitmapData();
			invalidateDisplayList();
		}
                
		/**
		 * 根据目标创建位图（目标大小变化时执行）
		 * 
		 */
		protected function createBitmapData():void
		{
			bitmapData && bitmapData.dispose();
			
			var rect: Rectangle = _target.getBounds(_target);
			if (rect.width && rect.height)
				bitmapData = new BitmapData(rect.width,rect.height,true,0);
		}
		/** @inheritDoc*/
		protected override function updateDisplayList(): void
		{
			super.updateDisplayList();
			
			if (_target)
				render()
		}
		
		/**
		 * 目标内容变化时执行
		 * 
		 */
		protected function render():void
		{
			var rect: Rectangle = _target.getBounds(_target);
			var m:Matrix = new Matrix();
			m.translate(-rect.x, -rect.y);
			bitmapData.fillRect(bitmapData.rect,0);
			bitmapData.draw(_target,m);
			
			renderBitmap();
		}
		
		/**
		 * 之后更新显示位图
		 * 
		 */
		public function invalidateRenderBitmap():void
		{
			renderBitmapCall.invalidate();
		}
		
		/**
		 * 重绘时显示位图
		 * 
		 */
		protected function renderBitmap():void
		{
			var rect: Rectangle = _target.getBounds(_target);
			var m:Matrix = new Matrix();
			m.createBox(1,1,0,rect.x,rect.y);
			graphics.clear();
			graphics.beginBitmapFill(bitmapData,m,false);
			graphics.drawRect(rect.x,rect.y,rect.width,rect.height);
			graphics.endFill();
		}
		
		private function handleTargetResize(event: ResizeEvent): void
		{
			updateTargetResize();
		}
		
		private function handleTargetMove(event: MoveEvent): void
		{
			updateTargetMove();
		}
		
		private function handleTargetUpdateComplete(event: GEvent): void
		{
			updateDisplayList();
		}
		                
		private function addTargetEvents():void
		{
			if (!_target)
				return;
			
			_target.addEventListener(GEvent.UPDATE_COMPLETE, handleTargetUpdateComplete);
			_target.addEventListener(MoveEvent.MOVE, handleTargetMove);
			_target.addEventListener(ResizeEvent.RESIZE, handleTargetResize);
		}
		
		private function removeTargetEvents():void
		{
			if (!_target)
				return;
		
			_target.removeEventListener(GEvent.UPDATE_COMPLETE, handleTargetUpdateComplete);
			_target.removeEventListener(MoveEvent.MOVE, handleTargetMove);
			_target.removeEventListener(ResizeEvent.RESIZE, handleTargetResize);
		}
		/** @inheritDoc*/
		public override function destory():void
		{
			super.destory();
			
			removeTargetEvents();
			bitmapData && bitmapData.dispose();
		}
	}
}