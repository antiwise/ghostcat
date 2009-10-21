package ghostcat.ui.controls
{
	import flash.display.BitmapData;
	import flash.filters.BitmapFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 位图字体，可以对单字使用filter
	 * @author flashyiyi
	 * 
	 */
	public class GBitmapText extends GText
	{
		/**
		 * 未添加滤镜的原始BitmapData
		 */
		protected var normalBitmapData:BitmapData;
		
		public function GBitmapText(skin:*=null, replace:Boolean=true, separateTextField:Boolean=false, textPos:Point=null)
		{
			super(skin, replace, separateTextField, textPos);
			
			this.asTextBitmap = true;
		}
		
		/** @inheritDoc*/
		public override function reRenderTextBitmap() : void
		{
			super.reRenderTextBitmap();
			if (normalBitmapData)
				normalBitmapData.dispose();
			normalBitmapData = textBitmap.bitmapData.clone();
		}
		
		/**
		 * 应用滤镜
		 * 
		 * @param filter
		 * @param startIndex
		 * @param endIndex
		 * 
		 */
		public function applyFilter(filter:BitmapFilter,startIndex:int,endIndex:int):void
		{
			for (var i:int = startIndex; i < endIndex; i++)
			{
				var rect:Rectangle = textField.getCharBoundaries(i);
				textBitmap.bitmapData.applyFilter(normalBitmapData,rect,rect.topLeft,filter);
			}
		}
		
		/**
		 * 设置背景色
		 * 
		 * @param color
		 * @param startIndex
		 * @param endIndex
		 * 
		 */
		public function setBackgroundColor(color:uint,startIndex:int,endIndex:int):void
		{
			for (var i:int = startIndex; i < endIndex; i++)
			{
				var rect:Rectangle = textField.getCharBoundaries(i);
				textBitmap.bitmapData.fillRect(rect,color);
				textBitmap.bitmapData.copyPixels(normalBitmapData,rect,rect.topLeft,null,null,true);
			}
		}
		
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (destoryed)
				return;
			
			if (normalBitmapData)
				normalBitmapData.dispose();
			
			super.destory();
		}
	}
}