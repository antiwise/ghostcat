package ghostcat.util.display
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * 此类用于查找显示对象
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class SearchUtil
	{
		/**
		 * 遍历子对象，找到某个类型的第一个实例
		 * @param displayObj 目标
		 * @param classRef	要查询的类
		 * @return 
		 * 
		 */
		public static function findChildByClass(displayObj:DisplayObject, classRef:Class, depth:int = int.MAX_VALUE):DisplayObject
        {
        	if (displayObj is classRef)
                return displayObj;
                
            if (displayObj is DisplayObjectContainer && depth > 0)
            {
                var contain:DisplayObjectContainer = DisplayObjectContainer(displayObj);
                for (var i:int=0;i < contain.numChildren;i++) 
                {
                    var child:DisplayObject = findChildByClass(contain.getChildAt(i), classRef, depth - 1);
                    if (child)
                    	return child;
                }
            }
            return null;
        }
        /**
         * 遍历子对象，找到某个类型的所有实例
         * @param displayObj	目标
         * @param classRef	要查询的类
         * @param result	返回值也会存在这里，可以在这里共用一个返回值，将多个结果集合并在一起
         * @return	找到对象的数组
         * 
         */        
        public static function findChildrenByClass(displayObj:DisplayObject, classRef:Class, depth:int = int.MAX_VALUE, result:Array=null):Array
        {
            if (result == null)
                result = [];
            
            if (displayObj is classRef)
                result.push(displayObj);
                
            if (displayObj is DisplayObjectContainer && depth > 0)
            {
                var contain:DisplayObjectContainer = DisplayObjectContainer(displayObj);
                for (var i:int=0;i < contain.numChildren;i++) 
                    findChildrenByClass(contain.getChildAt(i), classRef, depth - 1, result);
            }
            return result;
        }
        
        /**
         * 遍历父层对象，找到某个类型的第一个实例
         * @param displayObj	目标
         * @param classRef	要查询的类
         * @return 
         * 
         */        
        public static function findParentByClass(displayObj:DisplayObject, classRef:Class, depth:int = int.MAX_VALUE):DisplayObject
        {
            if (displayObj is classRef)
                return displayObj;
            
            if (displayObj.parent && displayObj.parent != displayObj && depth > 0)
                return findParentByClass(displayObj.parent, classRef, depth - 1);
                
            return null;
        }
        /**
         * 遍历父对象，找到某个类型的所有实例
         * @param displayObj	目标
         * @param classRef	要查询的类
         * @param result	返回值也会存在这里，可以在这里共用一个返回值，将多个结果集合并在一起
         * @return 
         * 
         */        
        private static function findParentsByClass(displayObj:DisplayObject, classRef:Class, depth:int = int.MAX_VALUE, result:Array=null):Array
        {
            if (result == null)
                result = [];
            
            if (displayObj is classRef)
                result.push(displayObj);
            
            if (displayObj.parent && displayObj.parent != displayObj && depth > 0)
                findParentsByClass(displayObj.parent, classRef, depth - 1, result);
                
            return result;
        }
        
        /**
         * 遍历子对象，找到第一个有某个属性值的对象
         * 诸如当property为name时，便是寻找特定实例名的子对象
         * 
         * @param displayObject	目标
         * @param property	要查询的属性
         * @param value	属性的值，设为null则表示不限制property的值
         * @return 
         * 
         */        
        public static function findChildByProperty(displayObj:DisplayObject, property:String, value:*=null, depth:int = int.MAX_VALUE):DisplayObject
        {
            if (displayObj == null)
                return null;
            
            if (displayObj.hasOwnProperty(property))
            {
            	if (value && displayObj[property] == value || value==null)
            	    return displayObj;
            }
                
            if (displayObj is DisplayObjectContainer && depth > 0)
            {
                var displayObjectContainer:DisplayObjectContainer = DisplayObjectContainer(displayObj);
                for (var i:int = 0;i < displayObjectContainer.numChildren;i++) 
                {
                	var child:DisplayObject = findChildByProperty(displayObjectContainer.getChildAt(i),property, value, depth - 1);
                    if (child)
                        return child;
                }
            }
            return null;
        }
        
        /**
         * 遍历父对象，找到第一个有某个属性值的对象
         * 
         * @param displayObject	目标
         * @param property	要查询的属性
         * @param value	属性的值，设为null则表示不限制property的值
         * @return 
         * 
         */        
        public static function findParentByProperty(displayObj:DisplayObject, property:String, value:*=null, depth:int = int.MAX_VALUE):DisplayObject
        {
            if (displayObj == null)
                return null;
            
            if (displayObj.hasOwnProperty(property))
            {
            	if (value && displayObj[property] == value || value==null)
            	    return displayObj;
            }
            
            if (displayObj.parent && displayObj.parent != displayObj && depth > 0)
                return findParentByProperty(displayObj.parent, property, value, depth - 1);
                
            return null;
        }
        
        /**
         * 遍历子对象，设置所有相应的属性
         * 诸如当property为mouseEnabled时，可以将子对象全部禁用鼠标
         * 
         * @param displayObject	目标
         * @param property	要设置的属性
         * @param value	属性的值
         * @return 
         * 
         */        
        public static function setPropertyByChild(displayObj:DisplayObject, property:String, value:*, depth:int = int.MAX_VALUE):void
        {
            if (displayObj == null)
                return;
            
            if (displayObj.hasOwnProperty(property))
            	displayObj[property] = value;
                
            if (displayObj is DisplayObjectContainer && depth > 0)
            {
                var displayObjectContainer:DisplayObjectContainer = DisplayObjectContainer(displayObj);
                for (var i:int = 0;i < displayObjectContainer.numChildren;i++) 
                	setPropertyByChild(displayObjectContainer.getChildAt(i), property, value, depth - 1);
            }
        }
        
        /**
         * 遍历父对象，设置所有相应的属性
         * 
         * @param displayObject	目标
         * @param property	要设置的属性
         * @param value	属性的值
         * @return 
         * 
         */        
        public static function setPropertyByParent(displayObj:DisplayObject, property:String, value:*, depth:int = int.MAX_VALUE):void
        {
            if (displayObj == null)
                return;
            
            if (displayObj.hasOwnProperty(property))
            	displayObj[property] = value;
            
            if (displayObj.parent && displayObj.parent != displayObj && depth > 0)
                setPropertyByParent(displayObj.parent, property, value, depth - 1);
        }		
	}
}