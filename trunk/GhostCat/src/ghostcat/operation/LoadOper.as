package ghostcat.operation
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
	
	import ghostcat.events.OperationEvent;
	import ghostcat.manager.FileCacherManager;
	import ghostcat.util.text.URL;
	import ghostcat.ui.controls.IProgressTargetClient;
	import ghostcat.util.data.LocalStorage;
	
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
		 * 始终使用嵌入资源 
		 */
		public static var alawayUseEmbedClass:Boolean = false;
		
		/**
		 * SharedObject缓存版本号(为空则禁用)
		 */
		public static var sharedObjectCacheVersion:String;
		
		/**
		 * 原始地址
		 */
		public var url:String;
		
		/**
		 * 路径
		 */		
		public var request:URLRequest;
		
		/**
		 * 是否禁用SharedObject缓存
		 */
		public var disibledCache:Boolean;
		
		
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
		protected var _loader:EventDispatcher;
		
		
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
		 * 是否加载跨域文件
		 */
		public var checkPolicyFile:Boolean = false;
		
		/**
		 * @param url	路径
		 * 载入SWF时将会默认使用当前应用域以及安全域。
		 * 
		 * @param embedClass	包含数据的Class，它只会在loader为空或者loader加载失败的时候载入。
		 * 可以用[Embed(source="xxx.swf",mimeType="application/octet-stream")]将资源以类的形式嵌入SWF。
		 * 
		 * 这样做是出于一个综合考虑。资源文件加入的方式，无非是编译期间的SWC，以及运行期间的SWF。SWC虽然可以集中管理资源，避免将SWF打散成块。
		 * 但比起SWF，就会有一个很麻烦的问题：美工和策划无法在修改资源文件后立即看到效果，因为它必须编译！这会在协作上造成很大的不便。
		 * 
		 * 这种方式是则是一个中间产物。如果两个参数都有值，在开发期间，可以提供外部资源文件，供美工测试用，嵌入的资源会被忽略，
		 * 而发布时，删除所有资源文件即可。这样可以解决很多问题。
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
		
		/**
		 * 立即加载，扩展名为swf,jpg,png,gif的将会使用Loader加载，可以用LOADER_TYPE修改规则。
		 * 
		 */		
		public override function execute():void
		{
			var isLoader:Boolean;
			if (this.type == AUTO && request)
				isLoader = (LOADER_TYPE.indexOf(new URL(request.url).pathname.extension) != -1);
			else
				isLoader = (this.type == LOADER);
			
			var bytes:ByteArray;
			if (embedClass && alawayUseEmbedClass || !request)
			{
				bytes = new embedClass();
				embedClass = null;
			}
			else if (sharedObjectCacheVersion && url && !disibledCache)
			{
				bytes = FileCacherManager.instance.load(url,sharedObjectCacheVersion);
			}
			
			if (isLoader)
			{
				var loader:Loader = new Loader();
				_loader = loader;
				
				if (bytes)
				{
					loadEmbedClass(bytes);
				}
				else
				{
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE,result);
					loader.contentLoaderInfo.addEventListener(Event.INIT,initHandler);
					loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progressHandler);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,fault);
					if (useCurrentDomain)
					{
						var loaderContext:LoaderContext = new LoaderContext(checkPolicyFile,ApplicationDomain.currentDomain);
						if (Security.sandboxType == Security.REMOTE)
							loaderContext.securityDomain = SecurityDomain.currentDomain;
					}
					else
					{
						loaderContext = new LoaderContext(checkPolicyFile);
					}
					
					loader.load(request,loaderContext);
				}
			}
			else
			{
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				_loader = urlLoader;
				
				if (bytes)
				{
					loadEmbedClass(bytes);
				}
				else
				{
					urlLoader.addEventListener(Event.COMPLETE,result);
					urlLoader.addEventListener(ProgressEvent.PROGRESS,progressHandler);
					urlLoader.addEventListener(IOErrorEvent.IO_ERROR,fault);
					urlLoader.load(request);
				}
			}
		
			super.execute();
		}
		
		public override function result(event:*=null):void
		{
			dispatchEvent(event);
		
			var evt:EventDispatcher = event.currentTarget as EventDispatcher;
			evt.removeEventListener(Event.COMPLETE,result);
			evt.removeEventListener(Event.INIT,initHandler);
			evt.removeEventListener(ProgressEvent.PROGRESS,progressHandler);
			evt.removeEventListener(IOErrorEvent.IO_ERROR,fault);
			
			if (sharedObjectCacheVersion && url && !disibledCache)
				saveToShareObject();
			
			super.result(event);		
		}
		
		public override function fault(event:*=null):void
		{
			dispatchEvent(event);
			
			(event.target as EventDispatcher).removeEventListener(Event.COMPLETE,result);
			(event.target as EventDispatcher).removeEventListener(Event.INIT,initHandler);
			(event.target as EventDispatcher).removeEventListener(ProgressEvent.PROGRESS,progressHandler);
			(event.target as EventDispatcher).removeEventListener(IOErrorEvent.IO_ERROR,fault);
		
			if (embedClass)
			{
				var bytes:ByteArray = new embedClass();
				embedClass = null;
			
				loadEmbedClass(bytes);
			}
			else
			{
				super.fault(event);
			}
		}
		
		private function loadEmbedClass(byteArr:ByteArray):void
		{
			if (_loader is Loader)
			{
				var oper:Loader = _loader as Loader;
				oper.contentLoaderInfo.addEventListener(Event.COMPLETE,result);
				oper.loadBytes(byteArr,new LoaderContext(false,useCurrentDomain ? ApplicationDomain.currentDomain: null));
			}
			else
			{
				var urlLoader:URLLoader = _loader as URLLoader;
				urlLoader.data = byteArr;
				super.result(_loader);
			}
		}
		
		protected function initHandler(event:Event):void
		{
			if (stopAtInit && _loader is Loader)
			{
				var loader:Loader = _loader as Loader;
				if (loader.content is MovieClip)
					MovieClip(loader.content).stop();
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
		
			if (_loader is Loader)
				Loader(_loader).close();
			
			if (_loader is URLLoader)
				URLLoader(_loader).close();
		}
		
		/**
		 * 卸载SWF
		 * 
		 */
		public function unload():void
		{
			if (_loader is Loader)
				Loader(_loader).unload();
		}
		
		/**
		 * 获取loaderInfo对象
		 * 独立应用域的数据必须从这个属性的applicationDomain里取得。只当execute执行后才有值。
		 */		
		public function get loaderInfo():LoaderInfo
		{
			return _loader is Loader ? Loader(_loader).contentLoaderInfo: null;
		}
		
		/**
		 * 获取加载事件发送器，可由此监听下载进度
		 * Loader是其contentLoaderInfo,URLLoader则是其本身。只当execute执行后才有值。
		 */
		public function get eventDispatcher():IEventDispatcher
		{
			return _loader is Loader ? Loader(_loader).contentLoaderInfo: _loader;
		}
		
		/**
		 * 载入的数据
		 */		
		public function get data():*
		{
			if (_loader is Loader)
			{
				return Loader(_loader).content;
			}
			else if (_loader is URLLoader)
			{
				var byteArr:ByteArray = URLLoader(_loader).data as ByteArray;
				if (dataFormat == URLLoaderDataFormat.BINARY)
					return byteArr;
				else if (dataFormat == URLLoaderDataFormat.VARIABLES)
					return new URLVariables(byteArr.readUTFBytes(byteArr.bytesAvailable))
				else
					return byteArr.toString();
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
			if (_loader is Loader)
				return Loader(_loader).contentLoaderInfo.bytes;
			else if (_loader is URLLoader)
				return URLLoader(_loader).data as ByteArray;
			else
				return null;
		}
		
		/**
		 * 获得已加载的数据大小 
		 * @return 
		 * 
		 */
		public function get bytesLoaded():int
		{
			return this.eventDispatcher["bytesLoaded"];
		}
		
		/**
		 * 获得数据总大小 
		 * @return 
		 * 
		 */
		public function get bytesTotal():int
		{
			return this.eventDispatcher["bytesTotal"];
		}
	}
}