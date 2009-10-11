package ghostcat.display.bitmap
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	import ghostcat.util.Util;
	import ghostcat.util.display.MatrixUtil;
	
	/**
	 * 位图高速缓存，适用于同屏大量活动对象的情景
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class BitmapScreen extends GBitmap
	{
		private var _alphaMultiplier:Boolean;
		
		/**
		 * 背景色
		 */
		public var backgroundColor:uint;
		
		/**
		 * 是否每次重绘（每次重绘将会忽略所有特效）
		 */
		public var redraw:Boolean = true;
		
		/**
		 * 需要应用的物品
		 */
		public var children:Array = [];
		
		/**
		 * 物品绘制时附加的颜色
		 */
		public var itemColorTransform:ColorTransform;
		
		/**
		 * 
		 * @param width
		 * @param height
		 * @param transparent	是否使用透明通道
		 * @param backgroundColor	背景色
		 * 
		 */
		public function BitmapScreen(width:Number,height:Number,transparent:Boolean = true,backgroundColor:uint = 0xFFFFFF):void
		{
			this.backgroundColor = backgroundColor;
			
			super(new BitmapData(width,height,transparent,backgroundColor));
			
			this.enabledTick = true;
		}
		
		/**
		 * 添加
		 * @param obj
		 * 
		 */
		public function addChild(obj:*):void
		{
			children.push(obj);
		}
		
		/**
		 * 删除 
		 * @param obj
		 * 
		 */
		public function removeChild(obj:*):void
		{
			Util.remove(children,obj);
		}
		
		/** @inheritDoc*/
		protected override function updateDisplayList() : void
		{
			if (redraw)
				bitmapData.fillRect(bitmapData.rect,backgroundColor)
				
			bitmapData.lock();
			for each (var obj:* in children)
				drawChild(obj);
			
			bitmapData.unlock();
			
			super.updateDisplayList();
		}
		
		/**
		 * 绘制物品
		 * @param obj
		 * 
		 */
		protected function drawChild(obj:*):void
		{
			if (obj is IBitmapDataDrawer)
			{
				(obj as IBitmapDataDrawer).drawToBitmapData(bitmapData);
			}
			else if (obj is DisplayObject)
			{
				var m:Matrix = MatrixUtil.getMatrixBetween(obj as DisplayObject,this,this.parent);
				bitmapData.draw(obj as DisplayObject,m,itemColorTransform);
			}
		} 
	}
}