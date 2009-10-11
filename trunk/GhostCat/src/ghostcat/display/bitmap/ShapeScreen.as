package ghostcat.display.bitmap
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	import ghostcat.display.GBase;
	import ghostcat.util.Util;
	import ghostcat.util.display.MatrixUtil;
	
	/**
	 * 另一种位图高速缓存，适用于同屏大量活动对象的情景
	 * 它在FP10下的性能远高于BitmapScreen，但在FP9下性能非常糟糕。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ShapeScreen extends GBase
	{
		/**
		 * 是否每次重绘
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
		
		
		public function ShapeScreen():void
		{
			super(null);
			
			this.enabledTick = true;
		}
		
		/**
		 * 添加
		 * @param obj
		 * 
		 */
		public function addShapeChild(obj:*):void
		{
			children.push(obj);
		}
		
		/**
		 * 删除 
		 * @param obj
		 * 
		 */
		public function removeShapeChild(obj:*):void
		{
			Util.remove(children,obj);
		}
		
		/** @inheritDoc*/
		protected override function updateDisplayList() : void
		{
			if (redraw)
				graphics.clear();
				
			for each (var obj:* in children)
				drawChild(obj);
			
			super.updateDisplayList();
		}
		
		/**
		 * 绘制物品
		 * @param obj
		 * 
		 */
		protected function drawChild(obj:*):void
		{
			if (obj is IShapeDrawer)
				(obj as IShapeDrawer).drawToShape(graphics);
		} 
	}
}