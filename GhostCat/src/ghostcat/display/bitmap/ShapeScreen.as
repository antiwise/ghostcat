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
	 * 容纳位图显示的对象
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ShapeScreen extends GBase
	{
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
			{
				(obj as IShapeDrawer).drawToShape(graphics);
			}
//			else if (obj is DisplayObject)
//			{
//				var m:Matrix = MatrixUtil.getMatrixBetween(obj as DisplayObject,this,this.parent);
//				bitmapData.draw(obj as DisplayObject,m,itemColorTransform);
//			}
		} 
	}
}