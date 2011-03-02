package ghostcat.manager
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import ghostcat.debug.Debug;
	import ghostcat.events.OperationEvent;
	import ghostcat.operation.LoadOper;
	import ghostcat.operation.LoadTextOper;
	import ghostcat.operation.Oper;
	import ghostcat.operation.Queue;
	import ghostcat.operation.load.QueueLoadOper;
	import ghostcat.text.URL;
	import ghostcat.ui.controls.GProgressBar;
	import ghostcat.util.core.Singleton;

	/**
	 * 资源管理类
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class AssetManager extends EventDispatcher
	{
		static private var _instance:AssetManager;
		static public function get instance():AssetManager
		{
			if (!_instance)
				_instance = new AssetManager();
			
			return _instance;
		}
		
		private var progressBar:GProgressBar;
		
		/**
		 * 资源加载的基本地址
		 */
		public var assetBase:String="";
		
		/**
		 * 资源类的基础包名
		 */		
		public var packageBase:String="";
		
		/**
		 * 使用的队列
		 */
		public var queue:Queue;
		
		/**
		 * 资源列表 
		 */
		public var opers:Dictionary;
		
		public function AssetManager():void
		{
			super();
			
			opers = new Dictionary();
			queue = Queue.defaultQueue;
		}
		
		/**
		 * 设置一个进度条显示加载进度
		 * @param v
		 * 
		 */
		public function setProgressBar(v:GProgressBar):void
		{
			this.progressBar = v;
		}
		
		/**
		 * 设置URL后缀
		 * @param v
		 * 
		 */
		public function setPostfix(v:String):void
		{
			LoadOper.postfix = v;
		}
		
		/**
		 * 获得路径全称
		 * @param v
		 * 
		 */
		public function getFullUrl(v:String):String
		{
			return URL.isHTTP(v) ? v : assetBase + v;
		}
		
		/**
		 * 载入一个资源
		 * 
		 * 加载结束可监听返回值的operation_complete事件
		 * 
		 * @param res	资源路径
		 * @param name	资源的名称，用于在进度条中显示
		 * @return 
		 * 
		 */
		public function loadResource(res:String,id:String=null,name:String = null):Oper
		{
			var oper:LoadOper = new LoadOper(getFullUrl(res));
			
			if (id)
				oper.id = id;
			
			if (name)
				oper.name = name;
			
			if (progressBar)
				progressBar.commitTarget(oper);
			
			oper.addEventListener(OperationEvent.OPERATION_COMPLETE,loadCompleteHandler);
			oper.commit(queue);
			return oper;
		}
		
		/**
		 * 加载完成后保存结果 
		 * @param event
		 * 
		 */
		protected function loadCompleteHandler(event:OperationEvent):void
		{
			var oper:Oper = event.currentTarget as Oper;
			oper.removeEventListener(OperationEvent.OPERATION_COMPLETE,loadCompleteHandler);
			
			if (oper is QueueLoadOper)
			{
				var queue:QueueLoadOper = oper as QueueLoadOper;
				for each (var child:Oper in queue.opers)
				{
					if (child.id)
						opers[child.id] = child;
				}
			}
			else
			{
				if (oper.id)
					opers[oper.id] = oper;
			}
		}
		
		/**
		 * 批量载入资源
		 * 
		 * @param res	资源路径列表
		 * @param names 资源的名称，用于在进度条中显示
		 * 
		 * 加载结束可监听返回值的operation_complete事件
		 * @return 
		 * 
		 */
		public function loadResources(res:Array,ids:Array=null,names:Array = null,bytesTotal:int = -1,queueLimit:int = 1):QueueLoadOper
		{
			var loader:QueueLoadOper = new QueueLoadOper(assetBase);
			loader.loadResources(res,ids,names);
			loader.queueLimit = queueLimit;
			
			if (progressBar)
			{
				if (bytesTotal == -1)
				{
					progressBar.commitTargets(loader.children);
				}
				else
				{
					loader.setBytesTotal(bytesTotal);
					progressBar.commitTarget(loader);
				}
			}
			
			loader.addEventListener(OperationEvent.OPERATION_COMPLETE,loadCompleteHandler);
			loader.commit(queue);
			
			return loader;
		}
		
		/**
		 * 先读取一个XML配置文件，再根据配置文件的内容批量载入资源。
		 * Oper的名称将是配置文件的@id属性，地址则是@url属性，资源名称是@tip属性。
		 * 
		 * 加载结束可监听返回值的operation_complete事件
		 * 
		 * @param filePath	资源配置文件名称
		 * @return 
		 * 
		 */
		public function loadResourcesFromXMLFile(filePath:String,bytesTotal:int = -1,queueLimit:int = 1):QueueLoadOper
		{
			var loader:QueueLoadOper = new QueueLoadOper(assetBase);
			loader.loadResourcesFromXMLFile(filePath);
			loader.queueLimit = queueLimit;
			
			if (progressBar)
			{
				if (bytesTotal == -1)
				{
					loader.readyHandler = resConfigHandler;
					function resConfigHandler():void
					{
						progressBar.commitTargets(loader.children);
					}	
				}
				else
				{
					loader.setBytesTotal(bytesTotal);
					progressBar.commitTarget(loader);
				}
			}
			
			loader.addEventListener(OperationEvent.OPERATION_COMPLETE,loadCompleteHandler);
			loader.commit(queue);
			
			return loader;
		}
		
		/**
		 * 根据载入时的名称获取加载器，继而可以取得加载完成的资源
		 *  
		 * @param name
		 * @return 
		 * 
		 */
		public function getOper(id:String):LoadOper
		{
			return opers[id];
		}
		
		/**
		 * 删除载入的资源。只有这样做才能回收用loadResource加载的资源。
		 * 
		 * @param name
		 * @return 
		 * 
		 */
		public function deleteOper(id:String):Boolean
		{
			return (delete opers[id]);
		}
		
		/**
		 * 清空所有资源
		 * 
		 */
		public function clearOper():void
		{
			opers = new Dictionary();
		}
		
		/**
		 * 对所有SWF文件执行unload。当你加载SWF文件却只希望保留它的应用域时而不使用舞台时，就需要执行unload以保证舞台上的对象不会影响性能
		 * 
		 */
		public function unloadAll():void
		{
			for each (var child:LoadOper in opers)
				child.unload();
		}
		
		/**
		 * 根据名称获得类
		 * 
		 * @param ref
		 * @return 
		 * 
		 */
		public function getAssetByName(ref:String):Class
		{
			try
			{
				return getDefinitionByName(packageBase + ref) as Class;
			}
			catch (e:Error)
			{
				Debug.error(ref+"资源不存在");
			}
			return null;
		}
		
		/**
		 * 创建一个MovieClip
		 * 
		 * @param ref
		 * @return 
		 * 
		 */
		public function getMovieClip(ref:String):MovieClip
		{
			return new (this.getAssetByName(ref))() as MovieClip;
		}
		
		/**
		 * 创建一个Sprite
		 * 
		 * @param ref
		 * @return 
		 * 
		 */
		public function getSprite(ref:String):Sprite
		{
			var cls:Class = this.getAssetByName(ref) as Class;
			return new cls() as Sprite;
		}
		
		/**
		 * 创建一个BitmapData
		 * 
		 * @param ref
		 * @return 
		 * 
		 */
		public function getBitmapData(ref:String,width:int,height:int):BitmapData
		{
			var cls:Class = this.getAssetByName(ref) as Class;
			return new cls(width,height) as BitmapData;
		}
	}
}