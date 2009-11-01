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
		
		public function LocalStorage(name:String,field:String = "value"):void
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
                sharedObject.setProperty(field, data);
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
                return (sharedObject.data[field]);
            } 
            catch(e:Error) {};
            return null;
        }

    }
}
