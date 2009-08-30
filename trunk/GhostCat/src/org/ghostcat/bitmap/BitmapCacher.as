package org.ghostcat.bitmap
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * 位图缓存类。
	 * 
	 * 这个类缓存的是静态图形，动画缓存可使用MovieClipCacher类
	 * @see org.ghostcat.display.movieclip.MovieClipCacher
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class BitmapCacher
	{
		private static var cacheDict:Dictionary = new Dictionary(true);
		
		/**
         * 将矢量图缓存为位图
         * 
         * @param content	容器
         * @param rect	限定转换范围，这个范围是以content的坐标系为基准的。
         * 
         * 强制位图缓存一般都是用于缩放，因为FLASH复杂矢量图的缩放极其消耗资源，尤其是幅面较大的时候。
         * 设置此参数可以将缩放范围限定为某一区域，诸如屏幕内，可以大大增强性能。
         * 在缩小图像的时候，需要缓存屏幕之外的图形，可以用Geom.scaleRectByCenter方法将rect参数扩大面积
         * 
         * @param precision	这个参数是缩放的时候使用的。当放大图形的时候，位图会变得模糊，将这个值设置为最大缩放比，将会以缩放到最大
         * 时的图形精度来缓存位图，这样即使放大位图仍然可以保持图像清晰。
         * 
         * @return	返回生成的位图。因此，这个方法也可以顺带作为截屏方法使用。
         */        
        public function swapContentForBitmap(content:DisplayObjectContainer,rect:Rectangle=null,precision:Number=1.0):Bitmap
        {
        	if (!rect)
        		rect = content.getBounds(content);
        	
        	var tmp:Rectangle = rect.clone();
            tmp.inflate((precision - 1) * rect.width, (precision - 1) * rect.height);
            
            var data:BitmapData = new BitmapData(rect.width * precision, rect.height * precision);
            data.draw(content, new Matrix(precision, 0, 0, precision, -rect.x * precision, -rect.y * precision), 
            		  null, null, null,true);
           
            var bitmap:Bitmap = new Bitmap(data);
            cacheDict[content] = bitmap;
            
            bitmap.name ="contentBitmap";
            bitmap.x = tmp.x;
            bitmap.y = tmp.y;
            bitmap.scaleX = bitmap.scaleY = 1 / precision;
           
            for (var i:int = 0 ;i< content.numChildren;i++)
            	content.getChildAt(i).visible = false;
            
            content.addChild(bitmap);
            return bitmap;
        }
        
        /**
         * 取消位图缓存
         * 
         * @param content	容器
         * 
         */        
        public function swapBackToContent(content:DisplayObjectContainer):void
        {
        	var bitmap:Bitmap = cacheDict[content];
        	if (!bitmap)
        		return;
        	
        	bitmap.parent.removeChild(bitmap);
        	bitmap.bitmapData.dispose();
        	delete cacheDict[content];
        	
            for (var i:int = 0 ;i< content.numChildren;i++)
            {
            	var child:DisplayObject = content.getChildAt(i);
            	child.visible = true;
            }
        }
        
        /**
         * 取消所有位图缓存。
         * 
         * 位图的内存泄露是非常严重的事情，如果使用了此类缓存位图，结束时务必执行此方法确保能够全部回收
         * 
         */
        public function swapBackAllToContent():void
        {
        	for (var content:* in cacheDict)
        		swapBackToContent(content as DisplayObjectContainer);
        }
	}
}