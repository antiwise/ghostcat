package org.ghostcat.manager
{
	import flash.net.SharedObject;
	import flash.utils.getQualifiedClassName;
	
	import org.ghostcat.util.Singleton;
	
	/**
	 * 保存到FLASH本地缓存
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class LocalManager extends Singleton
	{
		/**
		 * 最小占用磁盘空间，建议将其设置到一个合适的值，避免重复提示用户增加缓存
		 */
		public var minDiskSpace:int = 0;
		
		static public function get instance():LocalManager
		{
			return Singleton.getInstanceOrCreate(LocalManager) as LocalManager;
		}
		
		/**
		 * 获得保存地址
		 *  
		 * @param obj	唯一对象
		 * @param field	对象的键
		 * @param id	用于判重的ID
		 * @return 
		 * 
		 */
		static public function getLocalPath(obj:*,id:String=""):String
		{
			return getQualifiedClassName(obj)+ id ? "(" + id + ")" : "";
		} 
		
		/**
		 * 保存一个数据
		 *  
		 * @param obj	唯一对象
		 * @param field	对象的键
		 * @param id	用于判重的ID
		 * 
		 */
		public function save(obj:*,id:String=""):void
		{
			var so:SharedObject = SharedObject.getLocal(getLocalPath(obj,id));
			so.data.value = obj;
			so.data.time = new Date();
			so.flush(minDiskSpace);
		}
		
		/**
		 * 读取一个数据
		 *  
		 * @param obj	唯一对象
		 * @param field	对象的键
		 * @param id	用于判重的ID
		 * @return 
		 * 
		 */
		public function load(obj:*,id:String=""):*
		{
			var so:SharedObject = SharedObject.getLocal(getLocalPath(obj,id));
			return so.data.value;
		}
		
		/**
		 * 读取一个当天的数据。其他日期的数据会被忽略
		 *  
		 * @param obj	唯一对象
		 * @param field	对象的键
		 * @param id	用于判重的ID
		 * @return 
		 * 
		 */
		public function loadToday(obj:*,id:String=""):*
		{
			var so:SharedObject = SharedObject.getLocal(getLocalPath(obj,id));
			var time:Date = so.data.time;
			var today:Date = new Date();
			if (time.fullYear == today.fullYear && time.month == today.month && time.date == today.date)
				return so.data.value;
			else
				return null;
		}
	}
}