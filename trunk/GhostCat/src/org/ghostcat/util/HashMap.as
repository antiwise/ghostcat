package org.ghostcat.util
{
	/**
	 * 虽然Object基本可以承担HashMap的功能，却依然有着众多缺陷。
	 * 诸如，键不能使用表达式，也不能使用常量，这使得它很容易写错
	 * 
	 * 此类暂时只解决这一个问题。
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public dynamic class HashMap extends Object
	{
		/**
		 * @param source	类型可以是一个数组或者Object，
		 * 
		 */		
		public function HashMap(source:*=null)
		{
			if (source is Array)
			{
				applyPropertiesFromArray(source as Array);
			}
			else
			{
				applyPropertiesFromObject(source);
			}
		}
		
		/**
		 * 从一个数组中取值
		 * 
		 * @param source	数组的唯一合法形式为[["key1",value1],["key2",value2],["key3",value3]]
		 */		
		public function applyPropertiesFromArray(source:Array):void
		{
			for (var i:int=0;i<source.length;i++)
			{
				try
				{
					this[source[i][0]] = source[i][1];
				}
				catch (e:Error)
				{
					throw new Error("参数形式不合法")
				}
			}	
		}
		
		/**
		 * 从一个Object中取值
		 * 
		 * @param source
		 * 
		 */		
		public function applyPropertiesFromObject(source:Object):void
		{
			for (var key:* in source)
			{
				this[key] = source[key];
			}
		}
		
		/**
		 * 将属性值复制到另一个封闭对象上
		 * 
		 * @param target	目标对象，为一封闭类
		 * 
		 */		
		public function parse(target:Object):void
		{
			for (var key:* in this)
			{
				if (target.hasOwnProperty(key))
					target[key] = this[key]
			}
		}
	}
}