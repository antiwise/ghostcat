package org.ghostcat.util
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 一些用于图形的公用静态方法
	 * @author flashyiyi
	 * 
	 */
	public final class DisplayUtil
	{
	    /**
         * 检测对象是否在屏幕中
         * 
         * @param displayObj	显示对象
         * 
         */
        public static function inScreen(displayObj:DisplayObject):Boolean
        {
        	if (displayObj.stage == null)
        		return false;
            
			var screen:Rectangle = Geom.getRect(displayObj.stage);
            return screen.containsRect(displayObj.getBounds(displayObj.stage));
        }
        
		
		/**
		 * 移除所有子对象
		 * @param container	目标
		 * 
		 */
		public static function removeAllChildren(container:DisplayObjectContainer):void
        {
            while (container.numChildren) 
                container.removeChildAt(0);
        }
        /**
         * 将显示对象移至顶端
         * @param displayObj	目标
         * 
         */        
        public static function moveToHigh(displayObj:DisplayObject):void
        {
        	if (displayObj.parent)
        	{
        		var parent:DisplayObjectContainer = displayObj.parent;
        		if (parent.getChildIndex(displayObj) < parent.numChildren - 1)
        			parent.setChildIndex(displayObj, parent.numChildren - 1);
        	}
        }
        
        /**
         * 同时设置mouseEnabled以及mouseChildren。
         * 
         */        
        public static function setMouseEnabled(displayObj:DisplayObjectContainer,v:Boolean):void
        {
        	displayObj.mouseChildren = displayObj.mouseEnabled = v;
        }
        
        /**
         * 获取舞台Rotation
         * 
         * @param displayObj	显示对象
         * @return 
         * 
         */        
        public static function getStageRotation(displayObj:DisplayObject):Number
        {
        	var currentTarget:DisplayObject = displayObj;
			var r:Number = 1.0;
			
			while (currentTarget && currentTarget.parent != currentTarget)
			{
				r += currentTarget.rotation;
				currentTarget = currentTarget.parent;
			}
			return r;
        }
        
        /**
         * 获取舞台缩放比
         *  
         * @param displayObj
         * @return 
         * 
         */
        public static function getStageScale(displayObj:DisplayObject):Point
        {
        	var currentTarget:DisplayObject = displayObj;
			var scale:Point = new Point(1.0,1.0);
			
			while (currentTarget && currentTarget.parent != currentTarget)
			{
				scale.x *= currentTarget.scaleX;
				scale.y *= currentTarget.scaleY;
				currentTarget = currentTarget.parent;
			}
			return scale;
        }
        
        /**
         * 获取舞台Visible
         * 
         * @param displayObj	显示对象
         * @return 
         * 
         */        
        public static function getStageVisible(displayObj:DisplayObject):Boolean
        {
        	var currentTarget:DisplayObject = displayObj;
			while (currentTarget && currentTarget.parent != currentTarget)
			{
				if (currentTarget.visible == false) 
					return false;
				currentTarget = currentTarget.parent;
			}
			return true;
        }
        
        /**
         * 将矢量图缓存为位图
         * 
         * @param content	容器
         * @param rect	限定转换范围，这个范围是以content的坐标系为基准的。
         * 
         * 强制位图缓存一般都是用于缩放，因为FLASH复杂矢量图的缩放极其消耗资源，尤其是幅面较大的时候。
         * 设置此参数可以将缩放范围限定为某一区域，诸如屏幕内，可以大大增强性能。
         * 在缩小图像的时候，需要缓存屏幕之外的图形，可以用Geom.scaleRectByCenter方法将content参数扩大面积
         * 
         * @param precision	这个参数是缩放的时候使用的。当放大图形的时候，位图会变得模糊，将这个值设置为最大缩放比，将会以缩放到最大
         * 时的图形精度来缓存位图，这样即使放大位图仍然可以保持图像清晰。
         * 
         * @return	返回生成的位图。因此，这个方法也可以顺带作为截屏方法使用。
         */        
        public function swapContentForBitmap(content:DisplayObjectContainer,rect:Rectangle=null,precision:Number=1.0):Bitmap
        {
        	if (rect==null)
        		rect = content.getBounds(content);
        	
        	var tmp:Rectangle = rect.clone();
            tmp.inflate((precision - 1) * rect.width, (precision - 1) * rect.height);
            
            var data:BitmapData = new BitmapData(rect.width * precision, rect.height * precision);
            data.draw(content, new Matrix(precision, 0, 0, precision, -rect.x * precision, -rect.y * precision), 
            		  null, null, null,true);
           
            var bitmap:Bitmap = new Bitmap(data);
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
            for (var i:int = 0 ;i< content.numChildren;i++)
            {
            	var child:DisplayObject = content.getChildAt(i);
            	if (child.name!="contentBitmap" && child is Bitmap) 
            	{
            		content.removeChild(child);
            		(child as Bitmap).bitmapData.dispose();
            	}
            	else
            		child.visible = true;
            }
        }
        
		/**
		 * 自定义注册点缩放
		 * 
		 * @param displayObj	显示对象
		 * @param scaleX	缩放比X
		 * @param scaleY	缩放比Y
		 * @param point	新的注册点（相对于原注册点的坐标）
		 * 
		 */        
		public static function scaleAt(displayObj:DisplayObject,scaleX:Number,scaleY:Number,point:Point=null):void   
		{   
			if (!point)
				point = new Point();
			
			var m:Matrix = displayObj.transform.matrix;
			m.translate(-point.x,-point.y);  
			m.a = scaleX;
			m.d = scaleY;
			m.translate(point.x,point.y);   
			displayObj.transform.matrix = m;
		}
		   
		/**
		 * 自定义注册点旋转
		 * 
		 * @param displayObj	显示对象
		 * @param angle	旋转角度（0 - 360）
		 * @param point	新的注册点（相对于原注册点的坐标）
		 * 
		 */								
		public static function rotateAt(displayObj:DisplayObject,angle:Number,point:Point=null):void   
		{   
			if (!point)
				point = new Point();
			
			var m:Matrix = new Matrix();
			m.translate(-point.x, -point.y); 
			m.rotate(angle / 180 * Math.PI);
			m.translate(point.x, point.y);  
			displayObj.transform.matrix = m;
		}
		 
		/**
		 * 水平翻转
		 */
		public static function flipH(displayObj:DisplayObject):void
		{
			var m:Matrix = displayObj.transform.matrix.clone();
            m.a = -m.a;
            displayObj.transform.matrix = m;
		}
		
		/**
		 * 垂直翻转
		 */		
		public static function flipV(displayObj:DisplayObject):void
		{
			var m:Matrix = displayObj.transform.matrix.clone();
            m.d = -m.d;
            displayObj.transform.matrix = m;
		}
		
		/**
		 * 斜切
		 * 
		 * @param displayObj
		 * 
		 */
		public static function chamfer(displayObj:DisplayObject,dx:Number = 0,dy:Number = 0):void
		{
			var rect:Rectangle = displayObj.getRect(displayObj);
			
			var m:Matrix = displayObj.transform.matrix.clone();
			m.c = Math.tan(dx / rect.width);
            m.b = Math.tan(dy / rect.height);
            displayObj.transform.matrix = m;
        }
	}
}