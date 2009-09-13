package ghostcat.util
{
	import flash.utils.ByteArray;

	/**
	 * 
	 * 一些与数据相关的静态方法
	 * @author flashyiyi
	 * 
	 */	
	public final class Util
	{
		/**
		 * 判断一个对象是否是多个类中的一个
		 * 
		 * @param obj	对象
		 * @param classes	类型列表
		 * @return 是否在列表中
		 * 
		 */		
		public static function isIn(obj:*,classes:Array):Boolean
		{
			if (classes == null) 
				return false; 
			
			for (var i:int=0;i<classes.length;i++){
				if (obj is classes[i])
					return true;	
			}
			return false;
		}
		
		/**
		 * 从一个对象中删除一个值
		 * 
		 * @param obj	对象
		 * @param data	要删除的内容
		 * 
		 */		
		public static function remove(obj:*,data:*):void
		{
			var index:int;
			if (obj is Array)
			{
				index = (obj as Array).indexOf(data);
				if (index!=-1)
					data.splice(index, 1);
			}
			else
			{
				for (var key:* in obj)
				{
					if (obj[key]==data)
					{
						delete obj[key];
						return;
					}
				}
			}
		}
		
		/**
		 * 删除XML结点
		 * 
		 * @param data	XML结点
		 * 
		 */
		public static function removeXMLNote(data:XML):void
		{
			delete data.parent().*[data.childIndex()];
		}
		
		/**
		 * 合并两个动态对象
		 * 
		 * @param obj1	对象1
		 * @param obj2	对象2
		 * @return 
		 * 
		 */
		public static function unionObject(obj1:Object,obj2:Object):Object
		{
			var result:Object = new Object();
			var key:*;
			for (key in obj1)
				result[key] = obj1[key];
			
			for (key in obj2)
				result[key] = obj2[key];
				
			return result;
		}
		
		/**
		 * 对一组对象执行同一个方法
		 *  
		 * @param cmd	方法，参数为对象
		 * @param objs	对象数组
		 * @return 
		 * 
		 */
		public static function doAll(cmd:Function,objs:Array):Array
		{
			var result:Array = [];
			for (var i:int = 0;i < objs.length;i++)
				result.push(cmd(objs[i]));
			return result;
		}
		
		/**
		 * 创建一个对象并赋初值
		 * 
		 * @param obj	一个对象的实例或者一个类，类会自动实例化。
		 * @param values	初值对象
		 * @return 
		 * 
		 */
		public static function createObject(obj:*,values:Object):*
		{
			if (obj is Class)
				obj = new obj();
			
			for (var key:* in values)
				obj[key] = values[key];
			
			return obj;
		}
		
		/**
		 * 判断对象是否为空对象
		 * 
		 * @param obj
		 * @return 
		 * 
		 */
		public static function isEmpty(obj:*):Boolean
		{
			for (var o:* in obj)
				return false;
			
			return true;
		}
		
		/**
		 * 复制对象
		 *  
		 * @param obj
		 * @return 
		 * 
		 */
		public static function clone(obj:*):*
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(obj);
			bytes.position = 0;
			return bytes.readObject();
		}
		
		/**
		 * 比较对象是否内容相同（此操作较慢）
		 * 
		 * @param obj1
		 * @param obj2
		 * @return 
		 * 
		 */
		public static function equal(obj1:*,obj2:*):Boolean
		{
			var bytes1:ByteArray = new ByteArray();
			bytes1.writeObject(obj1);
			bytes1.position = 0;
			var bytes2:ByteArray = new ByteArray();
			bytes2.writeObject(obj2);
			bytes2.position = 0;
			if (bytes1.length == bytes2.length)
			{
				while (bytes1.bytesAvailable)
				{
					if (bytes1.readByte() != bytes2.readByte())
						return false;
				}
			}
			else
				return false;
			return true;
		}
	}
}