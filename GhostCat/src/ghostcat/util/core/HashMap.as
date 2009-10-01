package ghostcat.util.core
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	/**
	 * 实现部分HashMap的扩展功能
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public dynamic class HashMap extends Proxy
	{
		/**
		 * 原值 
		 */
		public var data:*;
		
		/**
		 * @param source	类型可以是一个数组或者Object，
		 * 
		 */		
		public function HashMap(source:*=null)
		{
			if (source is Array)
			{
				data = new Object();
				fromArray(source as Array);
			}
			else
				data = source;
		}
		
		/**
		 * 从一个数组中取值
		 * 
		 * @param source	数组的唯一合法形式为[["key1",value1],["key2",value2],["key3",value3]]
		 */		
		public function fromArray(source:Array):void
		{
			for (var i:int=0;i<source.length;i++)
			{
				try
				{
					data[source[i][0]] = source[i][1];
				}
				catch (e:Error)
				{
					throw new Error("参数形式不合法")
				}
			}	
		}
		
		/**
		 * 获得一个键的值
		 * 
		 * @param v
		 * @return 
		 * 
		 */
		public function find(v:String):*
		{
			return data[v];
		}
		
		/**
		 * 获得一个值的键
		 * 
		 * @param v
		 * @return 
		 * 
		 */
		public function findKey(v:*):String
		{
			for (var key:String in data)
			{
				if (data[key] == v)
					return key;
			}
			return null
		}
		
		/**
		 * 是否包含某个键
		 * 
		 * @param key
		 * @return 
		 * 
		 */
		public function containsKey(key:String):Boolean
		{
			return hasOwnProperty(key);
		}
		
		/**
		 * 是否包含某个值
		 * 
		 * @param v
		 * @return 
		 * 
		 */
		public function containsValue(v:*):Boolean 
		{
			return findKey(v)!=null;
		}
		
		/**
		 * 获得所有键
		 * 
		 * @return 
		 * 
		 */
		public function get keys():Array
		{
			var result:Array = [];
			for (var key:String in data)
				result.push(key);
			return result;
		}
		
		/**
		 * 获得所有值
		 *  
		 * @return 
		 * 
		 */
		public function get values():Array
		{
			var result:Array = [];
			for each (var v:* in data)
				result.push(v);
			return result;
		}
		
		/**
		 * 数据个数
		 *  
		 * @return 
		 * 
		 */
		public function get size():uint 
		{
			var l:int = 0;
			for (var o:* in data)
				l++;
			return l;
		}
		
		/**
		 * 是否为空
		 * @return 
		 * 
		 */
		public function get isEmpty():Boolean 
		{
			for (var o:* in data)
				return false;
			
			return true;
		}
		
		/**
		 * 删除一个键并返回其值
		 * 
		 * @param v
		 * @return 
		 * 
		 */
		public function remove(v:String):*
		{
			var d:* = data[v];
			if (delete (data[v]))
				return d;
			else
				return null;
		}
		
		/**
		 * 删除一个值并返回其键
		 *  
		 * @param v
		 * @return 
		 * 
		 */
		public function removeValue(v:*):String
		{
			var key:String = findKey(v);
			if (key)
			{
				if (delete data[key])
					return key;
				else
					return null;
			}
			else
				return null;
		}
		
		/**
		 * 清除所有内容
		 * 
		 */
		public function clear():void
		{
			for (var key:String in data)
				delete data[key];
		}
		
		/**
		 * 将属性值复制到另一个对象上
		 * 
		 */		
		public function copy(target:Object):void
		{
			for (var key:* in data)
				target[key] = data[key]
		}
		
		flash_proxy override function callProperty(methodName:*, ...args):*
		{
			var metrod:* = data[methodName];
			(metrod as Function).apply(null,args);
		}
		
		flash_proxy override function getProperty(property:*):* 
		{
			return data[property];
		}
		
		flash_proxy override function setProperty(property:*,value:*):void 
		{
			data[property] = value;
		}
		
		flash_proxy override function deleteProperty(property:*):Boolean 
		{
			return delete(data[property]);
		}
	}
}