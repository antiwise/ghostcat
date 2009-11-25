package ghostcat.util.data
{
	import flash.net.SharedObject;

    /**
     * 单值本地缓存对象
     * 
     * @author flashyiyi
     * 
     */
    public class LocalStorage
	{
		
        /**
         * 最小占用空间 
         */
        public var minDiskSpace:int = 0;

        /**
         * 本地储存对象实例 
         */
        public var sharedObject:SharedObject;
        
		private var field:String;
		
		public function LocalStorage(name:String):void
        {
            sharedObject = SharedObject.getLocal(name);
        }
        
        /**
         * 保存
         * @param name
         * @param data
         * 
         */
        public function setValue(data:*):void
        {
            try 
            {
                sharedObject.setProperty("value", data);
				sharedObject.setProperty("lastTime", new Date());
                sharedObject.flush(minDiskSpace);
            } 
            catch(e:Error) {};
        }
        
        /**
         * 载入
         * @param name
         * @return 
         * 
         */
        public function getValue():*
        {
            try 
            {
                return (sharedObject.data["value"]);
            } 
            catch(e:Error) {};
            return null;
        }
		
		public function getlastTime():Date
		{
			try 
			{
				return (sharedObject.data["lastTime"]);
			} 
			catch(e:Error) {};
			return null;
		}

    }
}
