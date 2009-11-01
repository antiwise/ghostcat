package ghostcat.operation
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;
	
	import ghostcat.events.OperationEvent;
	import ghostcat.text.URL;
	
	[Event(name="complete",type="flash.display.Event")]
	[Event(name="ioError",type="flash.display.IOErrorEvent")]
	[Event(name="progress",type="flash.events.ProgressEvent")]
	
	/**
	 * 文件加载器。
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class LoadOper extends RetryOper
	{
		public static const AUTO:String = "auto";
		public static const URLLOADER:String = "urlloader";
		public static const LOADER:String = "loader";
		
		/**
		 * 使用Loader的扩展名
		 */
		public static var LOADER_TYPE:Array = [".swf",".gif",".png",".jpg"];
		
		/**
		 * 路径
		 */		
		public var request:URLRequest;
		
		/**
		 * 载入方式
		 */
		public var type:String = AUTO;
		
		/**
		 * 载入格式
		 */		
		public var dataFormat:String = URLLoaderDataFormat.TEXT;
		
		/**
		 * 对象
		 */
		protected var obj:*;
		
		/**
		 * 陷入资源
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
				url = new URLRequest(url);
			
			this.request = url;
			this.embedClass = embedClass;
			
			if (embedClass)
				retry = 0;//如果有备用数据，则不需要重试
			
			if (rhandler!=null)
				this.addEventListener(OperationEvent.OPERATION_COMPLETE,rhandler);
			if (fhandler!=null)
				this.addEventListener(OperationEvent.OPERATION_ERROR,fhandler);
		}
		
		/**
		 * 立即加载，扩展名为swf,jpg,png,gif的将会使用Loader加载。
		 * 
		 */		
		public override function execute():void
		{
			super.execute();
			
			var isLoader:Boolean;
			if (this.type == AUTO)
				isLoader = (LOADER_TYPE.indexOf(new URL(request.url).pathname.extension) != -1);
			else if (this.type == LOADER)
				isLoader = true;
			else
				isLoader = false;
			
			if (isLoader)
			{
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,result);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progressHandler);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,fault);
				if (useCurrentDomain)
				{
					var loaderContext:LoaderContext = new LoaderContext(true,ApplicationDomain.currentDomain);
					if (Security.sandboxType == Security.REMOTE)
						loaderContext.securityDomain = SecurityDomain.currentDomain;
						
					loader.load(request,loaderContext);
				}
				else
				{
					loader.load(request);
				}
				obj = loader;
			}
			else
			{
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.dataFormat = dataFormat;
				urlLoader.addEventListener(Event.COMPLETE,result);
				urlLoader.addEventListener(ProgressEvent.PROGRESS,progressHandler);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR,fault);
				urlLoader.load(request);
				
				obj = urlLoader;
			}
		}
		
		public override function result(event:*=null):void
		{
			dispatchEvent(event);
			
			(event.target as EventDispatcher).removeEventListener(Event.COMPLETE,result);
			(event.target as EventDispatcher).removeEventListener(ProgressEvent.PROGRESS,progressHandler);
			(event.target as EventDispatcher).removeEventListener(IOErrorEvent.IO_ERROR,fault);
			
			super.result(event);		
		}
		
		public override function fault(event:*=null):void
		{
			dispatchEvent(event);
			
			(event.target as EventDispatcher).removeEventListener(Event.COMPLETE,result);
			(event.target as EventDispatcher).removeEventListener(ProgressEvent.PROGRESS,progressHandler);
			(event.target as EventDispatcher).removeEventListener(IOErrorEvent.IO_ERROR,fault);
			
			if (embedClass)
			{
				var byteArr:ByteArray = new embedClass();
				
				embedClass = null;
				
				if (obj is Loader)
				{
					var oper:Loader = obj as Loader;
					oper.contentLoaderInfo.addEventListener(Event.COMPLETE,result);
					oper.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progressHandler);
					oper.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,fault);
					oper.loadBytes(byteArr,new LoaderContext(true,ApplicationDomain.currentDomain));
				}
				else if (obj is URLLoader)
				{
					var urlLoader:URLLoader = obj as URLLoader;
					
					if (urlLoader.dataFormat == URLLoaderDataFormat.BINARY)
						urlLoader.data = byteArr;
					else
						urlLoader.data = byteArr.readUTFBytes(byteArr.bytesAvailable);
					
					super.result(event);
				}
			}
			else
			{
				super.fault(event);
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
		
			if (obj is Loader)
				(obj as Loader).close();
			
			if (obj is URLLoader)
				(obj as URLLoader).close();
		}
		
		/**
		 * 获取loaderInfo对象
		 * 独立应用域的数据必须从这个属性的applicationDomain里取得。
		 */		
		public function get loaderInfo():LoaderInfo
		{
			return (obj is Loader)?(obj as Loader).contentLoaderInfo: null;
		}
		
		/**
		 * 获取加载事件发送器，可由此监听下载进度
		 * Loader是其contentLoaderInfo,URLLoader则是其本身
		 */
		public function get eventDispatcher():EventDispatcher
		{
			return (obj is Loader)?(obj as Loader).contentLoaderInfo: obj;
		}
		
		/**
		 * 载入的数据
		 */		
		public function get data():*
		{
			if (obj is Loader)
				return (obj as Loader).content;
			else if (obj is URLLoader)
				return (obj as URLLoader).data;
			else
				return null;
		}
	}
}