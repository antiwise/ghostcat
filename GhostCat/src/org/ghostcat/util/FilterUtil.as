package org.ghostcat.util
{
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import org.ghostcat.util.CallLater;

	/**
	 * 滤镜处理类 
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class FilterUtil
	{
		/**
         * 增加一个滤镜，同类滤镜将会覆盖
         * 
         * @param displayObj	显示对象
         * @param filter	滤镜对象
         * 
         */        
        public static function applyFilter(displayObj:DisplayObject,filter:Object):void
        {
        	var filters:Array=displayObj.filters;
        	var dirty:Boolean = false;
        	var filterType:Class = getDefinitionByName(getQualifiedClassName(filter)) as Class;
        	if (filters)
        	{
        		var len:int = filters.length;
        		for (var i:int=0;i < len;i++)
        		{
        			if (filters[i] is filterType)
        			{
        				filters[i] = filter;
        				dirty = true;
        				break;
        			}
        		}
        	}
        
        	displayObj.filters = (dirty)? filters : [filter];
        }
        /**
         * 取消所有特定内容的滤镜
         * 
         * @param displayObj	显示对象
         * @param filterType	滤镜类型
         * 
         */        
        public static function removeFilter(displayObj:DisplayObject,filterType:Class):void
        {
        	var filters:Array=displayObj.filters;
        	var dirty:Boolean = false;
        	if (filters)
        	{
        		var len:int = filters.length;
        		for (var i:int=0;i < len;i++)
        		{
        			if (filters[i] is filterType)
        			{
        				filters.splice(i,1);
        				dirty = true;
        			}
        		}
        		
        		if (dirty)
        			displayObj.filters = filters;
        	}
        }
        
        /**
         * 更新滤镜
         * 
         * @param displayObj
         * @param immedie	是否立即执行
         * 
         */
        public static function refreshFilter(displayObj:DisplayObject,immedie:Boolean = true):void
        {
        	if (immedie)
        		refreshFilterImmediy(displayObj);
        	else
        		CallLater.callLater(refreshFilterImmediy,[displayObj],true,displayObj);
        		
        	
        }
        
        private static function refreshFilterImmediy(displayObj:DisplayObject):void
        {
        	displayObj.filters = displayObj.filters;
        }
	}
}