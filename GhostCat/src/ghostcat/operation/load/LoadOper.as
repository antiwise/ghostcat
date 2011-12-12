package ghostcat.operation.load
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import ghostcat.events.OperationEvent;
	import ghostcat.manager.FileCacherManager;
	import ghostcat.operation.RetryOper;
	import ghostcat.ui.controls.IProgressTargetClient;
	import ghostcat.util.data.LocalStorage;
	import ghostcat.util.text.URL;
	
	import mx.utils.object_proxy;
	
	[Event(name="complete",type="flash.display.Event")]
	[Event(name="ioError",type="flash.display.IOErrorEvent")]
	[Event(name="progress",type="flash.events.ProgressEvent")]
	
	/**
	 * 文件加载器。
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class LoadOper extends RetryOper implements IProgressTargetClient
	{
		public static const AUTO:String = "auto";
		public static const URLLOADER:String = "urlloader";
		public static const LOADER:String = "loader";
		
		/**
		 * 地址的后缀
		 */
		public static var postfix:String = "";
		
		/**
		 * 使用Loader作为加载器的文件扩展名
		 */
		public static var LOADER_TYPE:Array = ["swf","gif","png","jpg"];
		
		/**
		 * 在request和embedClass同时存在时依然优先使用嵌入资源 
		 */
		public static var alawayUseEmbedClass:Boolean;
		
		/**
		 * SharedObject缓存版本号(为空则禁用，设置值后会前从永久的SharedObject中查找资源缓存)
		 */
		public static var sharedObjectCacheVersion:String;
		
		/**
		 * 是否激活临时ByteArray缓存，这个操作会占用额外的内存
		 */
		public static var enabledByteArrayCache:Boolean = true;
		
		/**
		 * 临时ByteArray缓存
		 */
		public static var byteArrayCache:Dictionary = new Dictionary();
		
		/**
		 * 清除一个临时ByteArray缓存 
		 * @param url
		 * 
		 */
		public static function clearByteArrayCache(url:String):void
		{
			delete byteArrayCache[url];
		}
		
		/**
		 * 原始地址
		 */
		public var url:String;
		
		/**
		 * 路径
		 */		
		public var request:URLRequest;
		
		/**
		 * 是否在sharedObjectCacheVersion生效时临时禁用永久SharedObject缓存
		 */
		public var disibledCache:Boolean;
		
		/**
		 * 是否临时禁用ByteArray缓存
		 */
		public var disibledByteArrayCache:Boolean;
		
		
		private var _name:String;

		/**
		 * 用于在进度条中显示说明
		 */
		public function get name():String
		{
			return _name ? _name : id;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		
		/**
		 * 载入方式
		 */
		public var type:String = AUTO;
		
		/**
		 * 载入格式
		 */		
		public var dataFormat:String = URLLoaderDataFormat.TEXT;
		
		/**
		 * 加载对象
		 */
		protected var _urlLoader:URLLoader;
		
		/**
		 * 加载对象
		 */
		protected var _loader:Loader;
		
		
		/**
		 * 是否在开始加载的时候stop动画
		 */
		public var stopAtInit:Boolean = false;
		
		/**
		 * 嵌入资源
		 */
		protected var embedClass:Class;
		
		/**
		 * 是否使用当前应用域以及安全域
		 * 
		 * 当使用当前域时，加载进来的内容和直接编译产生的结果是一样的。因为编译进来的类无法被卸载，所以它们也不可能被卸载。
		 * 因为编译的内容不允许重名，所以它们也不允许重名。重名问题可以用增加不同的包名来解决。
		 * 
		 * 不使用当前域，加载进来的内容会拥有独立域，要读取它们的内容必须将loaderInfo属性保存起来，再用它的applicationDomain.getDefinition()方法来反射。
		 * 
		 * 独立域最好只在不确定载入资源状况的情况下使用，诸如载入用户上传的SWF。
		 *  
		 */		
		public var useCurrentDomain:Boolean = true;
		
		/**
		 * @param url	路径
		 * 载入SWF时将会默认使用当前应用域以及安全域。
		 * 
		 * @param embedClass	包含数据的Class，它只会在loader为空或者loader加载失败的时候载入。
		 * 可以用[Embed(source="xxx.swf",mimeType="application/octet-stream")]将资源以类的形式嵌入SWF。
		 * 
		 */		
		public function LoadOper(url:*=null,embedClass:Class=null,rhandler:Function=null,fhandler:Function=null)
		{
			if (url is String)
			{
				this.url = url;
				this.request = new URLRequest(url + postfix);
			}
			else if (url is URLRequest)
			{
				this.request = url as URLRequest;
				this.url = this.request.url
			}
						
			this.embedClass = embedClass;
			
			if (embedClass)
				retry = 0;//如果有备用数据，则不需要重试
			
			if (rhandler!=null)
				this.addEventListener(OperationEvent.OPERATION_COMPLETE,rhandler);
			
			if (fhandler!=null)
				this.addEventListener(OperationEvent.OPERATION_ERROR,fhandler);
		}
		
		/**
		 * 将加载完的数据存入ShareObject
		 * @param version
		 * 
		 */
		public function saveToShareObject(version:String = null):void
		{
			if (!version)
				version = sharedObjectCacheVersion;
			
			if (!version)
				return;
			
			FileCacherManager.instance.saveBytes(url,this.bytes,version);
		}
		
		public function getCacheBytes():ByteArray
		{
			var bytes:ByteArray;
			if (embedClass && alawayUseEmbedClass || !request)
			{
				bytes = new embedClass();
				embedClass = null;
			}
			else if (enabledByteArrayCache && byteArrayCache[url] && !disibledByteArrayCache)
			{
				bytes = byteArrayCache[url];
			}
			else if (sharedObjectCacheVersion && url && !disibledCache)
			{
				bytes = FileCacherManager.instance.load(url,sharedObjectCacheVersion);
			}
			return bytes;
		}
		
		/**
		 * 立即加载，扩展名为swf,jpg,png,gif的将会使用Loader加载，可以用LOADER_TYPE修改规则。
		 * 
		 */		
		public override function execute():void
		{
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			
			var bytes:ByteArray = getCacheBytes();
			if (bytes)
			{
				_urlLoader.data = bytes;
				urlLoadCompleteHandler();
			}
			else
			{
				_urlLoader.addEventListener(Event.COMPLETE,urlLoadCompleteHandler);
				_urlLoader.addEventListener(ProgressEvent.PROGRESS,progressHandler);
				_urlLoader.addEventListener(IOErrorEvent.IO_ERROR,fault);
				_urlLoader.load(request);
			}
			
			super.execute();
		}
		
		protected function urlLoadCompleteHandler(event:Event = null):void
		{
			_urlLoader.removeEventListener(Event.COMPLETE,urlLoadCompleteHandler);
			
			var isLoader:Boolean;
			if (this.type == AUTO && request)
				isLoader = (LOADER_TYPE.indexOf(new URL(request.url).pathname.extension) != -1);
			else
				isLoader = (this.type == LOADER);
			
			if (isLoader)
			{
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,result);
				_loader.contentLoaderInfo.addEventListener(Event.INIT,initHandler);
				_loader.load(request,new LoaderContext(false,useCurrentDomain ? ApplicationDomain.currentDomain : null));
			}
			else
			{
				result(event ? event : new Event(Event.COMPLETE))
			}
		}
		
		protected function clearEvents():void
		{
			if (_urlLoader)
			{
				_urlLoader.removeEventListener(Event.COMPLETE,urlLoadCompleteHandler);
				_urlLoader.removeEventListener(Event.INIT,initHandler);
				_urlLoader.removeEventListener(ProgressEvent.PROGRESS,progressHandler);
				_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,fault);
			}
			
			if (_loader)
			{
				_loader.removeEventListener(Event.COMPLETE,result);
				_loader.removeEventListener(Event.INIT,initHandler);
			}
		}
		
		public override function result(event:*=null):void
		{
			clearEvents();
			
			if (enabledByteArrayCache && !disibledByteArrayCache)
				byteArrayCache[url] = this.bytes;
			
			if (sharedObjectCacheVersion && url && !disibledCache)
				saveToShareObject();
			
			dispatchEvent(event);
			super.result(event);
		}
		
		public override function fault(event:*=null):void
		{
			clearEvents();
		
			if (embedClass)
			{
				var bytes:ByteArray = new embedClass();
				embedClass = null;
			
				_urlLoader.data = bytes;
				urlLoadCompleteHandler();
				
				return;
			}
			
			dispatchEvent(event);
			super.fault(event);
		}
		
		protected function initHandler(event:Event):void
		{
			if (stopAtInit && _loader)
			{
				if (_loader.content is MovieClip)
					MovieClip(_loader.content).stop();
			}
		}
		
		protected function progressHandler(event:ProgressEvent):void
		{
			dispatchEvent(event);
		}
		
		/**
		 * 中断下载进度，从队列中移除
		 */
		public override function halt():void
		{
			super.halt();
		
			if (_urlLoader)
			{
				try
				{
					_urlLoader.close();
				} 
				catch(error:Error) 
				{
					
				}
			}
		}
		
		/**
		 * 卸载SWF
		 * 
		 */
		public function unload():void
		{
			if (_loader)
				_loader.unload();
		}
		
		public function get loader():EventDispatcher
		{
			return _loader;
		}
		
		/**
		 * 获取loaderInfo对象
		 * 独立应用域的数据必须从这个属性的applicationDomain里取得。只当execute执行后才有值。
		 */		
		public function get loaderInfo():LoaderInfo
		{
			return _loader ? _loader.contentLoaderInfo: null;
		}
		
		/**
		 * 获取加载事件发送器，可由此监听下载进度
		 * Loader是其contentLoaderInfo,URLLoader则是其本身。只当execute执行后才有值。
		 */
		public function get eventDispatcher():IEventDispatcher
		{
			return _urlLoader;
		}
		
		/**
		 * 载入的数据
		 */		
		public function get data():*
		{
			if (_loader)
			{
				return _loader.content;
			}
			else if (_urlLoader)
			{
				var byteArr:ByteArray = _urlLoader.data as ByteArray;
				byteArr.position = 0;
				if (dataFormat == URLLoaderDataFormat.BINARY)
					return byteArr;
				else if (dataFormat == URLLoaderDataFormat.VARIABLES)
					return new URLVariables(byteArr.readUTFBytes(byteArr.bytesAvailable))
				else
				{
					//删除文件头
					var text:String = byteArr.toString();
					if (text.charCodeAt(0) == 65279)
						text = text.slice(1);
					return text;
				}
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * 载入数据的二进制形式 
		 * @return 
		 * 
		 */
		public function get bytes():ByteArray
		{
			var bytes:ByteArray = _urlLoader ? _urlLoader.data as ByteArray : null;
			if (bytes)
				bytes.position = 0;
			return bytes;
		}
		
		/**
		 * 获得已加载的数据大小 
		 * @return 
		 * 
		 */
		public function get bytesLoaded():int
		{
			return _urlLoader ? _urlLoader.bytesLoaded : 0;
		}
		
		/**
		 * 获得数据总大小 
		 * @return 
		 * 
		 */
		public function get bytesTotal():int
		{
			return _urlLoader ? _urlLoader.bytesTotal : 0;
		}
	}
}