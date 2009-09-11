package org.ghostcat.util
{
	import flash.net.SharedObject;

    /**
     * 本地缓存对象
     * 
     * @author flashyiyi
     * 
     */
    public class LocalStorage {

        /**
         * 名称
         */
        public var name:String;
        
        /**
         * 是否自动更新
         */
        public var autoFlush:Boolean;
        
        /**
         * 最小占用空间 
         */
        public var minDiskSpace:int = 0;

        /**
         * 本地储存对象 
         */
        public var sharedObject:SharedObject;
        
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
        public function save(name:String, data:*):void
        {
            try 
            {
                sharedObject.setProperty(name, data);
                if (autoFlush)
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
        public function load(name:String):*
        {
            try 
            {
                return (sharedObject.data[name]);
            } 
            catch(e:Error) {};
            return null;
        }
        
        /**
         * 更新
         * @param minDiskSpace
         * 
         */
        public function flush(minDiskSpace:int = 0):void
        {
        	sharedObject.flush(minDiskSpace);
        }

    }
}
