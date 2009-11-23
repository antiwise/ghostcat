package ghostcat.util.display
{
	import flash.display.Bitmap;
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
         * 获得子对象数组 
         * @param container
         * 
         */
        public static function getChildren(container:DisplayObjectContainer):Array
        {
        	var result:Array = [];
            for (var i:int = 0;i < container.numChildren;i++) 
                result.push(container.getChildAt(i));
            
        	return result;
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
		 * 批量增加子对象 
		 * 
		 */
		public static function addAllChildren(container:DisplayObjectContainer,children:Array):void
		{
			for (var i:int = 0;i < children.length;i++)
			{
				if (children[i] is Array)
					addAllChildren(container,children[i] as Array);
				else	
					container.addChild(children[i])
			}
		}
		
		/**
         * 将显示对象移至顶端
         * @param displayObj	目标
         * 
         */        
        public static function moveToHigh(displayObj:DisplayObject):void
        {
			var parent:DisplayObjectContainer = displayObj.parent;
			if (parent)
        	{
        		var lastIndex:int = parent.numChildren - 1;
        		if (parent.getChildIndex(displayObj) < lastIndex)
        			parent.setChildIndex(displayObj, lastIndex);
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
		 * 复制显示对象
		 * @param v
		 * 
		 */
		public static function cloneDisplayObject(v:DisplayObject):DisplayObject
		{
			var result:DisplayObject = v["constructor"]();
			result.filters = result.filters;
			result.transform.colorTransform = v.transform.colorTransform;
			result.transform.matrix = v.transform.matrix;
			if (result is Bitmap)
				(result as Bitmap).bitmapData = (v as Bitmap).bitmapData;
			return result;
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
	}
}