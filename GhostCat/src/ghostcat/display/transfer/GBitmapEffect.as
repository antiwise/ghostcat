package ghostcat.display.transfer
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import ghostcat.events.TickEvent;
	import ghostcat.util.Tick;
	import ghostcat.util.core.Handler;

	/**
	 * 缓存原始位图，用于处理位图实时特效
	 * 通过设置deep属性来控制特效动画播放
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
		
		/**
		 * 是否每次都要清除画布
		 */
		public var clearCanvas:Boolean = false;
		
		private var _deep:Number = 1.0;
		private var _enabledTickRender:Boolean;
		
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
		public override function createBitmapData():void
		{
			super.createBitmapData();
			
			if (normalBitmapData)
				normalBitmapData.dispose();
				
			this.normalBitmapData = this.bitmapData.clone();
		}
		
		/** @inheritDoc*/
		public override function renderTarget() : void
		{
			if (!normalBitmapData)
				return;
		
			var rect: Rectangle = target.getBounds(target);
			var m:Matrix = new Matrix();
			m.translate(-rect.x + paddingLeft, -rect.y + paddingTop);
			normalBitmapData.fillRect(normalBitmapData.rect,0);
			normalBitmapData.draw(_target,m);	
			
			renderEffect();
		}
		
		/**
		 * 从缓存的原始图像更新至实际图像
		 * 
		 */
		protected function renderEffect():void
		{
			if (clearCanvas)
				bitmapData.fillRect(bitmapData.rect,0);
			
			if (this.command && normalBitmapData)
				this.command.call(normalBitmapData,bitmapData,deep);
		}
		
		
		/**
		 * 开始逐帧事件 
		 * 
		 */
		public function start():void
		{
			this.enabledTickRender = true;
		}
		
		public function set enabledTickRender(v:Boolean):void
		{
			if (_enabledTickRender == v)
				return;
			
			_enabledTickRender = v;
			
			if (_enabledTickRender)
				Tick.instance.addEventListener(TickEvent.TICK,renderTickHandler);
			else
				Tick.instance.removeEventListener(TickEvent.TICK,renderTickHandler);
		}
		
		/**
		 * enabledTickRender开启的逐帧事件 
		 * @param event
		 * 
		 */
		protected function renderTickHandler(event:TickEvent):void
		{
			//
		}
		
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (normalBitmapData)
				normalBitmapData.dispose();
				
			this.enabledTickRender = false;
			
			super.destory();
		}
	}
}