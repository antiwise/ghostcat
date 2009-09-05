package org.ghostcat.bitmap.effect
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	
	import org.ghostcat.util.Util;
	import org.ghostcat.bitmap.GBitmap;

	/**
	 * 位图实现的残影效果
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ResidualScreen extends GBitmap
	{
		/**
		 * 渐隐速度（每次减少的透明度比例）
		 */
		public var fadeSpeed:Number;
		
		/**
		 * 模糊速度
		 */
		public var blurSpeed:Number;
		
		/**
		 * 位移速度 
		 */
		public var offest:Point;
		
		/**
		 * 附加的滤镜
		 */		
		public var effects:Array;
		
		/**
		 * 需要应用的物品
		 */
		public var items:Array = [];
		
		public function ResidualScreen(width:Number,height:Number):void
		{
			super(new BitmapData(width,height,true,0));
		}
		
		/**
		 * 添加
		 * @param obj
		 * 
		 */
		public function addItem(obj:DisplayObject):void
		{
			items.push(obj);
		}
		
		/**
		 * 删除 
		 * @param obj
		 * 
		 */
		public function removeItem(obj:DisplayObject):void
		{
			Util.remove(items,obj);
		}
		
		protected override function updateDisplayList() : void
		{
			super.updateDisplayList();
			
			if (fadeSpeed)
				bitmapData.applyFilter(bitmapData,bitmapData.rect,new Point(),
				new ColorMatrixFilter([1,0,0,0,0,
										0,1,0,0,0,
										0,0,1,0,0,
										0,0,0,fadeSpeed,0]
				));
			
			if (blurSpeed)
				bitmapData.applyFilter(bitmapData,bitmapData.rect,new Point(),new BlurFilter(blurSpeed,blurSpeed));
		
			if (offest)
				bitmapData.scroll(offest.x,offest.y);
				
			if (effects)
			{
				for each (var f:BitmapFilter in effects)
					bitmapData.applyFilter(bitmapData,bitmapData.rect,new Point(),f);
			}
			
			for each (var obj:DisplayObject in items)
			{
				bitmapData.draw(obj,obj.transform.matrix);
			}
		} 
	}
}