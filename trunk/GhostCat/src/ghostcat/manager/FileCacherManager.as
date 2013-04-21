package ghostcat.manager
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
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
		static public var localPath:String;
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
		public var fileList:SharedObject;
		
		public var version:String;
		
		public function FileCacherManager()
		{
			this.fileList = SharedObject.getLocal("fileCacher",localPath);
			this.fileList.addEventListener(NetStatusEvent.NET_STATUS,errorHandler);
			
			try
			{
				var o:Object = fileList.data;
			}
			catch (e:Error){};
			
			this.version = o ? o.version : null;
		}
		
		public function getFileCache(url:String):SharedObject
		{
			var sharedObject:SharedObject = SharedObject.getLocal("fileCacher_"+url,localPath);
			sharedObject.addEventListener(NetStatusEvent.NET_STATUS,errorHandler);
			return sharedObject;
		}
		
		private function errorHandler(event:Event):void
		{
			//
		}
		
		public function request(minDiskSpace:int,rHandler:Function = null,fHanlder:Function = null):void
		{
			try
			{
				if (fileList.flush(minDiskSpace) == SharedObjectFlushStatus.FLUSHED)
				{
					if (rHandler)
						rHandler();
				}
				else
				{
					fileList.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
				}
			}
			catch(e:Error)
			{
				if (fHanlder)
					fHanlder();
			}
			
			function onFlushStatus(event:NetStatusEvent):void 
			{
				fileList.removeEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
				switch (event.info.code)
				{
					case "SharedObject.Flush.Success":
						if (rHandler)
							rHandler();
						break;
					case "SharedObject.Flush.Failed":
						if (fHanlder)
							fHanlder();
						break;
				}
			}
		}
		
		public function checkVersion(v:String):void
		{
			if (fileList.data.version == v)
				return;
					
			this.clear();
			fileList.data.version = v;
			fileList.flush(minDiskSpace);
		}
		
		public function clear():void
		{
			if (fileList.data)
			{
				for (var v:String in fileList.data)
				{
					var so:SharedObject = getFileCache(v);
					so.clear();
				}
			}
			fileList.clear();
		}
		
		/**
		 * 加载并将数据存入缓存 
		 * @param url
		 * @param version
		 * @return 
		 * 
		 */
		public function save(url:String,version:String = null):Boolean
		{
			var v:Object = load(url);
			if (v)
				return false;
			
			var loader:URLLoader = new URLLoader(new URLRequest(url));
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE,saveCompleteHandler);
			return true;
		
			function saveCompleteHandler(event:Event):void
			{
				try
				{
					var sharedObject:SharedObject = getFileCache(url);
					sharedObject.setProperty("data",loader.data);
					sharedObject.flush(minDiskSpace);
					
					fileList.data[url] = true;
					fileList.flush(minDiskSpace);
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
		public function saveBytes(url:String,bytes:ByteArray,version:String = null):Boolean
		{
			var v:Object = load(url);
			if (v)
				return false;
			
			try
			{
				var sharedObject:SharedObject = getFileCache(url);
				sharedObject.setProperty("data",bytes);
				sharedObject.flush(minDiskSpace);
				
				fileList.data[url] = true;
				fileList.flush(minDiskSpace);
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
			try
			{
				var o:Object = getFileCache(url).data;
			}
			catch (e:Error){};
			return o ? o.data : null;
		}
	}
}



//package ghostcat.manager
//{
//	import flash.events.Event;
//	import flash.events.EventDispatcher;
//	import flash.events.IOErrorEvent;
//	import flash.events.NetStatusEvent;
//	import flash.net.SharedObject;
//	import flash.net.SharedObjectFlushStatus;
//	import flash.net.URLLoader;
//	import flash.net.URLLoaderDataFormat;
//	import flash.net.URLRequest;
//	import flash.utils.ByteArray;
//	
//	import ghostcat.util.core.Singleton;
//	
//	/**
//	 * 缓存文件至SharedObject
//	 * @author flashyiyi
//	 * 
//	 */
//	public class FileCacherManager extends EventDispatcher
//	{
//		static public var localPath:String;
//		static private var _instance:FileCacherManager;
//		static public function get instance():FileCacherManager
//		{
//			if (!_instance)
//				_instance = new FileCacherManager();
//			
//			return _instance;
//		}
//		/**
//		 * 最小占用空间 
//		 */
//		public var minDiskSpace:int = 20000000;
//		/**
//		 * 本地储存对象实例 
//		 */
//		public var sharedObject:SharedObject;
//		
//		public function FileCacherManager()
//		{
//			sharedObject = SharedObject.getLocal("fileCacher",localPath);
//			sharedObject.addEventListener(NetStatusEvent.NET_STATUS,errorHandler);
//		}
//		
//		private function errorHandler(event:Event):void
//		{
//			//
//		}
//		
//		public function request(minDiskSpace:int,rHandler:Function = null,fHanlder:Function = null):void
//		{
//			try
//			{
//				if (sharedObject.flush(minDiskSpace) == SharedObjectFlushStatus.FLUSHED)
//				{
//					if (rHandler)
//						rHandler();
//				}
//				else
//				{
//					sharedObject.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
//				}
//			}
//			catch(e:Error)
//			{
//				if (fHanlder)
//					fHanlder();
//			}
//			
//			function onFlushStatus(event:NetStatusEvent):void 
//			{
//				sharedObject.removeEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
//				switch (event.info.code)
//				{
//					case "SharedObject.Flush.Success":
//						if (rHandler)
//							rHandler();
//						break;
//					case "SharedObject.Flush.Failed":
//						if (fHanlder)
//							fHanlder();
//						break;
//				}
//			}
//		}
//		
//		public function checkVersion(v:String):void
//		{
//			if (sharedObject.data.version == v)
//				return;
//			
//			sharedObject.clear();
//			sharedObject.data.version = v;
//		}
//		
//		public function clear():void
//		{
//			sharedObject.clear();
//		}
//		
//		public function getVersion(url:String):String
//		{
//			try
//			{
//				var o:Object = sharedObject.data[url];
//			}
//			catch (e:Error){};
//			return o ? o.version : null
//		}
//		
//		/**
//		 * 加载并将数据存入缓存 
//		 * @param url
//		 * @param version
//		 * @return 
//		 * 
//		 */
//		public function save(url:String,version:String):Boolean
//		{
//			var oldVer:String = getVersion(url);
//			if (oldVer && oldVer >= version)
//				return false;
//			
//			var loader:URLLoader = new URLLoader(new URLRequest(url));
//			loader.dataFormat = URLLoaderDataFormat.BINARY;
//			loader.addEventListener(Event.COMPLETE,saveCompleteHandler);
//			return true;
//			
//			function saveCompleteHandler(event:Event):void
//			{
//				try
//				{
//					sharedObject.setProperty(url,{version:version,data:loader.data});
//					sharedObject.flush(minDiskSpace);
//				}
//				catch (e:Error){};
//				
//			}
//		}
//		
//		/**
//		 * 将数据存入缓存 
//		 * @param url
//		 * @param bytes
//		 * @param version
//		 * @return 
//		 * 
//		 */
//		public function saveBytes(url:String,bytes:ByteArray,version:String):Boolean
//		{
//			var oldVer:String = getVersion(url);
//			if (oldVer && oldVer >= version)
//				return false;
//			
//			try
//			{
//				sharedObject.setProperty(url,{version:version,data:bytes});
//				sharedObject.flush(minDiskSpace);
//			}
//			catch (e:Error){};
//			
//			return true;
//		}
//		
//		/**
//		 * 从缓存中加载文件 
//		 * @param url
//		 * @param version
//		 * @return 
//		 * 
//		 */
//		public function load(url:String,version:String = null):ByteArray
//		{
//			var oldVer:String = getVersion(url);
//			if (!oldVer || version && version > oldVer)
//				return null;
//			
//			try
//			{
//				var o:Object = sharedObject.data[url];
//			}
//			catch (e:Error){};
//			return o ? o.data : null;
//		}
//	}
//}