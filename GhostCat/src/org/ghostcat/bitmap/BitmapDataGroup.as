package org.ghostcat.bitmap
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;

	/**
	 * 在创建位图的时候保持他们的引用，以便不会遗漏执行它们的dispose方法。
	 * 如此可以节省编码时的精力
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class BitmapDataGroup
	{
		private static var _defaultGroup:BitmapDataGroup;
		
		/**
		 * 默认组
		 */		
		public static function get defaultGroup():BitmapDataGroup
		{
			if (!_defaultGroup)
				_defaultGroup = new BitmapDataGroup();
			return _defaultGroup;
		}
		
		private var bitmaps:Dictionary = new Dictionary();
		
		/**
		 * 创建
		 * 
		 * @param width	宽度
		 * @param height	高度
		 * @param transparent	是否透明
		 * @param fillColor	透明色
		 * @return 
		 * 
		 */
		public function create(width:int,height:int,transparent:Boolean=true,fillColor:uint=0xFFFFFFFF):BitmapData
		{
			var bitmap:BitmapData = new BitmapData(width,height,transparent,fillColor);
			bitmaps[bitmap]=true;
			return bitmap;
		}
		
		/**
		 * 复制位图
		 * @param source
		 * @return 
		 * 
		 */
		public function clone(source:BitmapData):BitmapData
		{
			var bitmap:BitmapData = source.clone();
			bitmaps[bitmap]=true;
			return bitmap;
		}
		
		/**
		 * 销毁位图
		 * @param bitmap
		 * 
		 */
		public function dispose(bitmap:BitmapData):void
		{
			bitmap.dispose();
			delete bitmaps[bitmap];
		}
		
		/**
		 * 销毁全部位图
		 * 
		 */
		public function disposeAll():void
		{
			for (var bitmap:* in bitmaps)
			{
				if (bitmap is BitmapData)
					dispose(bitmap as BitmapData);
			}
		}
		
		/**
		 * 包括到组里
		 * @param bitmap
		 * 
		 */
		public function cover(data:Array):void
		{
			for (var i:int = 0;i<(data as Array).length;i++)
			{
				var o:* = data[i];
				if (o is Bitmap)
					bitmaps[(o as Bitmap).bitmapData]=true;
				else if (o is BitmapData)
					bitmaps[o]=true;
			}
		}
		
		/**
		 * 查找所有子显示对象中的位图并包含进组里
		 * 
		 * @param display
		 * 
		 */
		public function findAndCover(display:DisplayObject):void
		{
			if (display is Bitmap)
				cover([display]);
			
			if (display is DisplayObjectContainer)
			{
				var container:DisplayObjectContainer = display as DisplayObjectContainer;
				for (var i:int = 0;i<container.numChildren;i++)
					findAndCover(container.getChildAt(i));
			}
		}
	}
}