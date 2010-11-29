package ghostcat.manager
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import ghostcat.util.core.Singleton;

	/**
	 * 缓存文件至SharedObject
	 * @author flashyiyi
	 * 
	 */
	public class FileCacherManager extends EventDispatcher
	{
		static private var _instance:FileCacherManager;
		static public function get instance():FileCacherManager
		{
			if (!_instance)
				_instance = new FileCacherManager();
			
			return _instance;
		}
		/**
		 * 最小占用空间 
		 */
		public var minDiskSpace:int = 20000000;
		/**
		 * 本地储存对象实例 
		 */
		public var sharedObject:SharedObject;
		
		public function FileCacherManager()
		{
			sharedObject = SharedObject.getLocal("fileCacher");
			sharedObject.addEventListener(NetStatusEvent.NET_STATUS,errorHandler);
		}
		
		private function errorHandler(event:Event):void
		{
			//
		}
		
		public function clear():void
		{
			sharedObject.clear();
		}
		
		public function getVersion(url:String):String
		{
			try
			{
				var o:Object = sharedObject.data[url];
			}
			catch (e:Error){};
			return o ? o.version : null
		}
		
		/**
		 * 加载并将数据存入缓存 
		 * @param url
		 * @param version
		 * @return 
		 * 
		 */
		public function save(url:String,version:String):Boolean
		{
			var oldVer:String = getVersion(url);
			if (oldVer && oldVer >= version)
				return false;
			
			var loader:URLLoader = new URLLoader(new URLRequest(url));
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE,saveCompleteHandler);
			return true;
		
			function saveCompleteHandler(event:Event):void
			{
				try
				{
					sharedObject.setProperty(url,{version:version,data:loader.data});
					sharedObject.flush(minDiskSpace);
				}
				catch (e:Error){};
				
			}
		}
		
		/**
		 * 将数据存入缓存 
		 * @param url
		 * @param bytes
		 * @param version
		 * @return 
		 * 
		 */
		public function saveBytes(url:String,bytes:ByteArray,version:String):Boolean
		{
			var oldVer:String = getVersion(url);
			if (oldVer && oldVer >= version)
				return false;
			
			try
			{
				sharedObject.setProperty(url,{version:version,data:bytes});
				sharedObject.flush(minDiskSpace);
			}
			catch (e:Error){};
		
			return true;
		}
		
		/**
		 * 从缓存中加载文件 
		 * @param url
		 * @param version
		 * @return 
		 * 
		 */
		public function load(url:String,version:String = null):ByteArray
		{
			var oldVer:String = getVersion(url);
			if (!oldVer || version && version > oldVer)
				return null;
			
			try
			{
				var o:Object = sharedObject.data[url];
			}
			catch (e:Error){};
			return o ? o.data : null;
		}
	}
}