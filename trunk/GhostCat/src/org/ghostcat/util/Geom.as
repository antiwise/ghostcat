package org.ghostcat.util
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;

    /**
     * 主要是一些处理矩形区域的方法
     * 
     * 显示对象与矩形的转换可以用getRect(obj)和scaleToFit(obj,rect)方法来承担。
     * 这个类的无类型参数可能的类型都是矩形或者显示对象
     * 
     * 其中坐标系若不作说明指的都是父对象坐标系
     * 
     * @author flashyiyi
     * 
     */	
    public final class Geom extends Object
    {
    	/**
		 * 拉伸对象到充满到某个区域
		 * 
		 * @param displayObj	显示对象
		 * @param rect	范围
		 * 
		 */		
		public static function scaleToFit(displayObj:DisplayObject, rect:Rectangle):void
        {
            displayObj.scaleX = rect.width / displayObj.width;
            displayObj.scaleY = rect.height / displayObj.height;
            
            var objRect:Rectangle = displayObj.getRect(displayObj.parent);
            displayObj.x += rect.x - objRect.x;
            displayObj.y += rect.y - objRect.y;
        }
        
		/**
		 * 获得矩形（以父容器为基准），这个方法主要是为了和scaleToFit方法配套，实现矩形和显示对象的转换
		 * 当源是stage时，获取的将不是图形矩形，而是舞台的矩形。必要的时候请用root代替。
		 * 
		 * @param obj	显示对象或者矩形，矩形将会被直接返回
		 * @param targetSpace	当前坐标系，默认值为父显示对象
		 * @return 
		 * 
		 */		
		public static function getRect(obj:*,space:DisplayObject=null):Rectangle
		{	
			if (!obj)
				return null;
			
			if (obj is Rectangle)
				return (obj as Rectangle).clone();
			
			if (obj is Stage)
			{
				var stageRect:Rectangle = new Rectangle(0,0,(obj as Stage).stageWidth,(obj as Stage).stageHeight);
				if (space)
					return localRectToContent(stageRect,obj as DisplayObject,space);
				else
					return stageRect;
			}
				
			if (obj is DisplayObject)
			{
				if (!space)
					space = (obj as DisplayObject).parent;
				return obj.getRect(space);
			}
			
			return null;
		}
		
		/**
		 * 转换坐标到某个显示对象
		 * 
		 * @param pos	坐标
		 * @param source	源
		 * @param target	目标
		 * @return 
		 * 
		 */		
		public static function localToContent(pos:Point,source:DisplayObject,target:DisplayObject):Point
		{
			if (target && source)
				return target.globalToLocal(source.localToGlobal(pos));
			else if (source)
				return source.localToGlobal(pos);
			else if (target)
				return target.globalToLocal(pos);
			return null;
		}
		
		/**
		 * 转换矩形坐标到某个显示对象
		 * 
		 * @param rect	矩形
		 * @param source	源
		 * @param target	目标
		 * @return 
		 * 
		 */		
		public static function localRectToContent(rect:Rectangle,source:DisplayObject,target:DisplayObject):Rectangle
		{
			var topLeft:Point = localToContent(rect.topLeft,source,target);
			var bottomRight:Point = localToContent(rect.bottomRight,source,target);
			return new Rectangle(topLeft.x,topLeft.y,bottomRight.x - topLeft.x,bottomRight.y - topLeft.y);
		}
		
        /**
         * 由中心点开始创建一个矩形
         * 
         * @param p	中心点
         * @param w	宽度
         * @param h	高度
         * @return 
         * 
         */    	
        public static function createCenterRect(p:Point, w:Number, h:Number):Rectangle
        {
            return new Rectangle(p.x - w / 2, p.y - h / 2, w, h);
        }

        /**
         * 获得中心点
         * 
         * @param obj	显示对象或者矩形
         * @return 
         * 
         */		
        public static function center(obj:*):Point
        {
        	var rect:Rectangle = getRect(obj);
        	return (rect)?new Point(rect.x + rect.width / 2, rect.y + rect.height / 2):null;
        }
        
        /**
         * 将某个矩形限定在另一个矩形的范围内（矩形大小不变）。左上的优先度较高。
         * 
         * @param obj	显示对象或者矩形
         * @param cotainer	矩形的限定范围
         * @return 是否已经移出范围
         * 
         */		
        public static function forceRectInside(obj:*, cotainer:*):Boolean
        {
        	var rect:Rectangle = getRect(obj);
        	var cotainRect:Rectangle = getRect(cotainer,obj.parent);
        	var topLeft:Point = rect.topLeft;
        	var out:Boolean = false;
            if (rect.right > cotainRect.right)
            {
                topLeft.x = cotainRect.right - rect.width;
            	out = true;
            }
            if (rect.x < cotainRect.x)
            {
                topLeft.x = cotainRect.x;
            	out = true;
            }
            if (rect.bottom > cotainRect.bottom)
            {
                topLeft.y = cotainRect.bottom - rect.height;
            	out = true;
            }
            if (rect.y < cotainRect.y)
            {
                topLeft.y = cotainRect.y;
            	out = true;
            }
            moveTopLeftTo(obj,topLeft);
            return out;
        }
        
        /**
         * 将某个点限定在另一个矩形的范围内。
         * 
         * @param obj	显示对象或者点
         * @param cotainer	点的限定范围
         * @return 是否已经移出范围
         * 
         */		
        public static function forcePointInside(obj:*, cotainer:*):Boolean
        {
        	var cotainRect:Rectangle = getRect(cotainer,obj.parent);
        	var out:Boolean = false;
            if (obj.x > cotainRect.right)
            {
                obj.x = cotainRect.right;
            	out = true;
            }
            if (obj.x < cotainRect.x)
            {
                obj.x = cotainRect.x;
            	out = true;
            }
            if (obj.y > cotainRect.bottom)
            {
                obj.y = cotainRect.bottom;
            	out = true;
            }
            if (obj.y < cotainRect.y)
            {
                obj.y = cotainRect.y;
            	out = true;
            }
            return out;
        }
        
        /**
         * 以中心点为基准放大矩形
         * 
         * @param obj	显示对象或者矩形
         * @param scale	缩放比
         * @return 
         * 
         */        
        public static function scaleByCenter(obj:*, scale:Number):void
        {
        	var rect:Rectangle = getRect(obj);
        	obj.width = obj.width * scale;
        	obj.height = obj.height * scale;
        	obj.x -= (obj.width - rect.width)/2;
        	obj.y -= (obj.height - rect.height)/2;
        }
        
        /**
         * 移动中心点至某个坐标
         * 
         * @param obj	显示对象或者矩形
         * @param target	目标坐标
         * 
         */        
        public static function moveCenterTo(obj:*,target:Point):void
        {
        	var center:Point = center(obj);
        	obj.x += target.x - center.x;
        	obj.y += target.y - center.y;
        }
        
        /**
         * 移动左上角坐标到某个坐标
         * 
         * @param obj
         * @param target
         * 
         */
        public static function moveTopLeftTo(obj:*,target:Point):void
        {
        	var topLeft:Point = getRect(obj).topLeft;
        	obj.x += target.x - topLeft.x;
        	obj.y += target.y - topLeft.y;
        }
        
        /**
         * 让对象在范围内居中
         * 
         * @param obj	显示对象或者矩形
         * @param cotainer	容器区域
         * 
         */        
        public static function centerIn(obj:*,cotainer:*):void
        {
        	moveCenterTo(obj,center(cotainer));
        }
        
        /**
         * 拷贝坐标
         * 
         * @param source	源数据
         * @param target	目标对象
         * 
         */
        public static function copyPosition(source:*,target:*):void
        {
        	target.x = source.x;
        	target.y = source.y;
        }
        
        /**
         * 将一个点包括在矩形内
         * 
         * @param source
         * @param x
         * @param y
         * 
         */
        public static function unionPoint(source:*,x:Number=NaN,y:Number=NaN):void
        {
        	var rect:Rectangle = getRect(source);
        	if (!isNaN(x))
        	{
				if (x < rect.x)
				{
					source.x = x;
					source.width = rect.right - x;
				}
				else if (x > rect.right)
				{
					source.width = x - rect.x;
				}
        	}
        	if (!isNaN(y))
        	{
				if (y < rect.y)
				{
					source.y = y;
					source.height = rect.bottom - y;
				}
				else if (y > rect.bottom)
				{
					source.height = y - rect.y;
				}
        	}
        }
    }
}


