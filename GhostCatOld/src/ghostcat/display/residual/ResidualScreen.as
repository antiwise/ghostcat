package ghostcat.display.residual
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import ghostcat.display.bitmap.BitmapScreen;
	import ghostcat.util.Util;
	import ghostcat.util.display.MatrixUtil;

	/**
	 * 位图实现的残影效果
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ResidualScreen extends BitmapScreen
	{
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
		 * 全屏附加的颜色
		 */
		public var colorTransform:ColorTransform;
		
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
			super(width,height,alphaMultiplier,backgroundColor);
			
			this.redraw = false;
			this.enabledMouseCheck = false;
			this.mouseEnabled = this.mouseChildren = false;
		}
		
		/** @inheritDoc*/
		protected override function updateDisplayList() : void
		{
			if (destoryed)
				return;
			
			if (mode != MODE_BITMAP)
				return;
			
			var bitmapData:BitmapData = (content as Bitmap).bitmapData;
			if (!redraw)
			{
				if (fadeTransform)
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
			super.updateDisplayList();
		}
	}
}