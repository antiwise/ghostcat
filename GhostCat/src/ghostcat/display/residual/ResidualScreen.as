package ghostcat.display.residual
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import ghostcat.display.bitmap.GBitmap;
	import ghostcat.util.Util;
	import ghostcat.util.display.MatrixUtil;

	/**
	 * 位图实现的残影效果
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ResidualScreen extends GBitmap
	{
		private var _alphaMultiplier:Boolean;
		
		/**
		 * 渐消滤镜
		 */
		protected var fadeTransform:ColorTransform;
		/**
		 * 模糊滤镜
		 */
		protected var blurFilter:BlurFilter;
		/**
		 * 位移速度 
		 */
		public var offest:Point;
		
		/**
		 * 附加的滤镜
		 */		
		public var effects:Array;
		
		/**
		 * 是否每次重绘（每次重绘将会忽略所有特效）
		 */
		public var redraw:Boolean = false;
		
		/**
		 * 物品绘制时附加的颜色
		 */
		public var itemColorTransform:ColorTransform;
		
		/**
		 * 全屏附加的颜色
		 */
		public var colorTransform:ColorTransform;
		
		/**
		 * 需要应用的物品
		 */
		public var items:Array = [];
		
		/**
		 * 是否使用透明通道
		 * @return 
		 * 
		 */
		public function get alphaMultiplier():Boolean
		{
			return _alphaMultiplier;
		}
		
		/**
		 * 背景色
		 */
		public var backgroundColor:uint;
		
		/**
		 * 模糊速度
		 */
		public function get blurSpeed():Number
		{
			return blurFilter.blurX;
		}

		public function set blurSpeed(v:Number):void
		{
			blurFilter = new BlurFilter(v,v);
		}

		/**
		 * 渐隐速度（每次减少的透明度比例）
		 */
		public function get fadeSpeed():Number
		{
			return fadeTransform.alphaMultiplier;
		}

		public function set fadeSpeed(v:Number):void
		{
			fadeTransform = new ColorTransform(1,1,1,v);
		}

		/**
		 * 
		 * @param width
		 * @param height
		 * @param alphaMultiplier	是否使用透明通道2
		 * @param backgroundColor	背景色
		 * 
		 */
		public function ResidualScreen(width:Number,height:Number,alphaMultiplier:Boolean = true,backgroundColor:uint = 0xFFFFFF):void
		{
			this._alphaMultiplier = alphaMultiplier;
			this.backgroundColor = backgroundColor;
			
			super(new BitmapData(width,height,alphaMultiplier,backgroundColor));
			this.enabledTick = true;
		}
		
		/**
		 * 添加
		 * @param obj
		 * 
		 */
		public function addItem(obj:*):void
		{
			items.push(obj);
		}
		
		/**
		 * 删除 
		 * @param obj
		 * 
		 */
		public function removeItem(obj:*):void
		{
			Util.remove(items,obj);
		}
		
		/** @inheritDoc*/
		protected override function updateDisplayList() : void
		{
			if (redraw)
			{
				bitmapData.fillRect(bitmapData.rect,backgroundColor)
			}
			else
			{
				if (fadeTransform && _alphaMultiplier)
					bitmapData.colorTransform(bitmapData.rect,fadeTransform);
				
				if (blurFilter)
					bitmapData.applyFilter(bitmapData,bitmapData.rect,new Point(),blurFilter);
				
				if (offest)
					bitmapData.scroll(offest.x,offest.y);
				
				if (colorTransform)
					bitmapData.colorTransform(bitmapData.rect,colorTransform);
				
				if (effects)
				{
					for each (var f:BitmapFilter in effects)
					bitmapData.applyFilter(bitmapData,bitmapData.rect,new Point(),f);
				}
			}
			bitmapData.lock();
			for each (var obj:* in items)
				drawItem(obj);
				
			bitmapData.unlock();
		}
		
		/**
		 * 绘制物品
		 * @param obj
		 * 
		 */
		protected function drawItem(obj:*):void
		{
			var m:Matrix = MatrixUtil.getMatrixBetween(obj as DisplayObject,this,this.parent);
			
			bitmapData.draw(obj as DisplayObject,m,itemColorTransform);
		} 
	}
}