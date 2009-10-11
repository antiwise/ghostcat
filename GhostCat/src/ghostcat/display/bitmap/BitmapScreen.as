package ghostcat.display.bitmap
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	import ghostcat.util.Util;
	import ghostcat.util.display.MatrixUtil;
	
	/**
	 * 容纳位图显示的对象
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
		 * 是否使用透明通道
		 * @return 
		 * 
		 */
		public function get alphaMultiplier():Boolean
		{
			return _alphaMultiplier;
		}
		
		/**
		 * 
		 * @param width
		 * @param height
		 * @param alphaMultiplier	是否使用透明通道2
		 * @param backgroundColor	背景色
		 * 
		 */
		public function BitmapScreen(width:Number,height:Number,alphaMultiplier:Boolean = true,backgroundColor:uint = 0xFFFFFF):void
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
				(obj as IBitmapDataDrawer).drawBitmapData(bitmapData);
			}
			else if (obj is DisplayObject)
			{
				var m:Matrix = MatrixUtil.getMatrixBetween(obj as DisplayObject,this,this.parent);
				bitmapData.draw(obj as DisplayObject,m,itemColorTransform);
			}
		} 
	}
}