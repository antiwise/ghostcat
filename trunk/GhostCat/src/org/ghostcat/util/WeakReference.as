package org.ghostcat.util
{
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import org.ghostcat.debug.Debug;
	
	/**
	 * 弱引用包装类
	 * 利用Dictionary的特性使得弱引用特性可以延展到其他对象上。
	 * 
	 * @author Administrator
	 * 
	 */
	dynamic public class WeakReference extends Proxy
	{
		private var dictionary:Dictionary;
		
		public function WeakReference(o:Object)
		{
			dictionary = new Dictionary(true);
			dictionary[o] = null;
		}
		
		/**
		 * 获取对象。
		 * 虽然这个类是代理类，可以直接设置属性，一般不建议这样使用，而是使用value属性将保存的对象取出，
		 * 并用强制类型转换来使用它。
		 * 
		 * @return 
		 * 
		 */
		public function get value():Object
		{
			for (var n:Object in dictionary)
				return n; 
			
			Debug.error("无法找到对象引用，它可能已经被回收了。");
			return null;
		}
		
		flash_proxy override function callProperty(methodName:*, ...args):*
		{
			var metrod:* = value[methodName];
			(metrod as Function).apply(null,args);
		}
		
		flash_proxy override function getProperty(property:*):* 
		{
			return value[property];
		}
		
		flash_proxy override function setProperty(property:*,value:*):void 
		{
			value[property] = value;
		}
		
		flash_proxy override function deleteProperty(property:*):Boolean 
		{
			return delete(value[property]);
		}
	}
}