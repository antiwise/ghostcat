package org.ghostcat.transfer
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import org.ghostcat.bitmap.GBitmap;
	import org.ghostcat.display.GBase;
	import org.ghostcat.events.GEvent;
	import org.ghostcat.events.MoveEvent;
	import org.ghostcat.events.ResizeEvent;

	
	/**
	 * 用于实时将显示对象转换为位图处理的类
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GBitmapTransfer extends GBitmap
	{
		protected var _target:DisplayObject;
		
		public function GBitmapTransfer(target:DisplayObject=null):void
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
			var rect:Rectangle = _target.getBounds(this);
			x = rect.x + this.x;
			y = rect.y + this.y;
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
		 * 创建位图 
		 * 
		 */
		protected function createBitmapData():void
		{
			bitmapData && bitmapData.dispose();
			
			var rect: Rectangle = _target.getBounds(_target);
			if (rect.width && rect.height)
				bitmapData = new BitmapData(rect.width,rect.height,true,0);
		}
		
		public override function updateDisplayList(): void
		{
			super.updateDisplayList();
			
			if (_target && stage)
			{
				render()
			}
		}
		
		protected function render():void
		{
			var rect: Rectangle = _target.getBounds(_target);
			var m:Matrix = new Matrix();
			m.translate(-rect.x, -rect.y);
			bitmapData.fillRect(bitmapData.rect,0);
			bitmapData.draw(_target,m);	
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
			if (_target && _target is GBase)
			{
				_target.addEventListener(GEvent.UPDATE_COMPLETE, handleTargetUpdateComplete);
				_target.addEventListener(MoveEvent.MOVE, handleTargetMove);
				_target.addEventListener(ResizeEvent.RESIZE, handleTargetResize);
			}
		}
		
		private function removeTargetEvents():void
		{
			if (_target && _target is GBase)
			{
				_target.removeEventListener(GEvent.UPDATE_COMPLETE, handleTargetUpdateComplete);
				_target.removeEventListener(MoveEvent.MOVE, handleTargetMove);
				_target.removeEventListener(ResizeEvent.RESIZE, handleTargetResize);
			}
		}
		
		public override function destory():void
		{
			super.destory();
			
			removeTargetEvents();
			bitmapData && bitmapData.dispose();
		}
	}
}