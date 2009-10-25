package ghostcat.transfer
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	import ghostcat.util.core.AbstractUtil;

	/**
	 * 缓存原始位图，用于处理位图实时特效
	 *  
	 * @author flashyiyi
	 * 
	 */
	public class GBitmapCacheTransfer extends GBitmapTransfer
	{
		/**
		 * 原始图像
		 */
		public var normalBitmapData:BitmapData;
		
		/**
		 * 渲染执行的方法（参数为normalBitmapData）
		 */
		public var command:Function;
		
		private var _deep:Number = 0.0;
		
		public function get deep():Number
		{
			return _deep;
		}
		
		public function set deep(value:Number):void
		{
			_deep = value;
			renderCache();
		}
		
		public function GBitmapCacheTransfer(target:DisplayObject=null)
		{
			super(target);
		}
		
		/** @inheritDoc*/
		public override function render():void
		{
			super.render();
			
			if (normalBitmapData)
				normalBitmapData.dispose();
			
			normalBitmapData = bitmapData.clone();
			
			renderCache();
		}
		
		/**
		 * 从缓存的原始图像更新至实际图像
		 * 
		 */
		protected function renderCache():void
		{
			if (this.command != null && normalBitmapData)
				this.command(normalBitmapData);
		}
		
		/** @inheritDoc*/
		public override function destory() : void
		{
			super.destory();
			
			if (normalBitmapData)
				normalBitmapData.dispose();
		}
	}
}