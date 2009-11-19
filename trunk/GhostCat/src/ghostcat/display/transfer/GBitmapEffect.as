package ghostcat.display.transfer
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filters.DropShadowFilter;
	
	import ghostcat.util.core.Handler;

	/**
	 * 缓存原始位图，用于处理位图实时特效
	 * 
	 * 特效方法都在ghostcat.display.transfer.effect包内
	 *  
	 * @author flashyiyi
	 * 
	 */
	public class GBitmapEffect extends GBitmapTransfer
	{
		/**
		 * 原始图像
		 */
		public var normalBitmapData:BitmapData;
		
		/**
		 * 渲染执行的方法（参数为normalBitmapData,bitmapData,deep）
		 * 参见ghostcat.display.transfer.effect包
		 */
		public var command:Handler;
		
		/**
		 * 是否根据alpha值决定特效的强度 
		 */
		public var byAlpha:Boolean = true;
		
		private var _deep:Number = 1.0;
		
		/**
		 * 当byAlpha为真时，此属性和deep属性的意义相同 
		 * @param value
		 * 
		 */
		public override function set alpha(value:Number) : void
		{
			if (byAlpha)
				deep = value;
			else
				super.alpha = value;
		}
		
		public override function get alpha() : Number
		{
			if (byAlpha)
				return deep;
			else
				return super.alpha;
		}
		
		/**
		 * 特效强度 
		 * @return 
		 * 
		 */
		public function get deep():Number
		{
			return _deep;
		}
		
		public function set deep(value:Number):void
		{
			_deep = value;
			renderEffect();
		}
		
		/**
		 *  
		 * @param target	渲染目标
		 * @param command	渲染方法：Function或者Handler类型
		 * 
		 */
		public function GBitmapEffect(target:DisplayObject=null,command:*=null)
		{
			if (command is Function)
				command = new Handler(command);
			
			this.command = command;
			
			super(target);
		}
		
		/** @inheritDoc*/
		public override function render():void
		{
			super.render();
			
			if (normalBitmapData)
				normalBitmapData.dispose();
			
			normalBitmapData = bitmapData.clone();
			
			renderEffect();
		}
		
		/**
		 * 从缓存的原始图像更新至实际图像
		 * 
		 */
		protected function renderEffect():void
		{
			bitmapData.fillRect(bitmapData.rect,0);
			
			if (this.command && normalBitmapData)
				this.command.call(normalBitmapData,bitmapData,deep);
		}
		
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (normalBitmapData)
				normalBitmapData.dispose();
		
			super.destory();
		}
	}
}