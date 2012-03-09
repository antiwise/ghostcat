package ghostcat.manager
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import ghostcat.debug.Debug;
	import ghostcat.events.OperationEvent;
	import ghostcat.operation.Oper;
	import ghostcat.operation.Queue;
	import ghostcat.operation.load.LoadOper;
	import ghostcat.operation.load.LoadTextOper;
	import ghostcat.operation.load.QueueLoadOper;
	import ghostcat.ui.controls.GProgressBar;
	import ghostcat.util.core.Singleton;
	import ghostcat.util.text.URL;

	/**
	 * 资源管理类
	 * 
	 * 加载完成应该监听queue属性的OPERATION_COMPLETE方法
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
		
		/**
		 * 资源加载的基本地址
		 */
		public var useCurrentDomain:Boolean = true;
		
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
		 * @param id	资源id
		 * @param name	资源的名称，用于在进度条中显示
		 * @return 
		 * 
		 */
		public function loadResource(res:String,id:String=null,name:String = null,inQueue:Boolean = true):Oper
		{
			var oper:LoadOper = new LoadOper(getFullUrl(res));
			oper.useCurrentDomain = this.useCurrentDomain;
			
			if (id)
				oper.id = id;
			else
				oper.id = res;
			
			if (name)
				oper.name = name;
			else
				oper.name = oper.id;
			
			if (progressBar)
				progressBar.commitTarget(oper);
			
			oper.addEventListener(OperationEvent.OPERATION_COMPLETE,loadCompleteHandler);
			if (inQueue)
				oper.commit(queue);
			else
				oper.execute();
			
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
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * 批量载入资源
		 * 
		 * @param res	资源路径列表
		 * @param ids 资源的ID
		 * @param names 资源的名称，用于在进度条中显示
		 * @param byetsTotal 预估总加载数据量，设置这个数值后整个加载过程会使用统一的加载进度
		 * @param queueLimit 同时加载的文件数量
		 * @param sizes 加载时各个文件分别的体积
		 * 
		 * 加载结束可监听返回值的operation_complete事件
		 * @return 
		 * 
		 */
		public function loadResources(res:Array,ids:Array=null,names:Array = null,bytesTotal:int = -1,queueLimit:int = 1,sizes:Array = null,inQueue:Boolean = true):QueueLoadOper
		{
			var loader:QueueLoadOper = new QueueLoadOper(assetBase);
			loader.useCurrentDomain = this.useCurrentDomain;
			loader.queueLimit = queueLimit;
			
			if (bytesTotal != -1)
				loader.setBytesTotal(bytesTotal);
			
			loader.loadResources(res,ids,names,sizes);
			
			if (progressBar)
			{
				if (loader.loadHelper.useRealTotalBytes)
				{
					progressBar.commitTargets(loader.children);
				}
				else
				{
					progressBar.commitTarget(loader);
				}
			}
			
			loader.addEventListener(OperationEvent.OPERATION_COMPLETE,loadCompleteHandler);
			if (inQueue)
				loader.commit(queue);
			else
				loader.execute();
			
			return loader;
		}
		
		/**
		 * 根据配置XML文件的内容批量载入资源。
		 * Oper的名称将是配置文件的@id属性，地址则是@url属性，显示出的资源名称是@name或者@tip属性。
		 * 可以增加@size属性来表示文件大小，但必须设置bytesTotal为0
		 * 
		 * 加载结束可监听返回值的operation_complete事件
		 * 
		 * @return 
		 * 
		 */
		public function loadResourcesFromXMLList(xml:XMLList,bytesTotal:int = -1,queueLimit:int = 1,inQueue:Boolean = true):QueueLoadOper
		{
			var loader:QueueLoadOper = new QueueLoadOper(assetBase);
			loader.useCurrentDomain = this.useCurrentDomain;
			loader.queueLimit = queueLimit;
			
			if (bytesTotal != -1)
				loader.setBytesTotal(bytesTotal);
			
			loader.loadResourcesFromXMLList(xml);
			
			if (progressBar)
			{
				if (loader.loadHelper.useRealTotalBytes)
				{
					progressBar.commitTargets(loader.children);
				}
				else
				{
					progressBar.commitTarget(loader);
				}
			}
			
			loader.addEventListener(OperationEvent.OPERATION_COMPLETE,loadCompleteHandler);
			if (inQueue)
				loader.commit(queue);
			else
				loader.execute();
			
			return loader;
		}
		
		public function loadResourcesFromXML(xml:XML,bytesTotal:int = -1,queueLimit:int = 1,inQueue:Boolean = true):QueueLoadOper
		{
			return loadResourcesFromXMLList(xml.children(),bytesTotal,queueLimit,inQueue);
		}
		
		/**
		 * 先读取一个XML配置文件，再根据配置文件的内容批量载入资源。
		 * Oper的名称将是配置文件的@id属性，地址则是@url属性，显示出的资源名称是@name或者@tip属性。
		 * 可以增加@size属性来表示文件大小，但必须设置bytesTotal为0
		 * 
		 * 加载结束可监听返回值的operation_complete事件
		 * 
		 * @param filePath	资源配置文件名称
		 * @return 
		 * 
		 */
		public function loadResourcesFromXMLFile(filePath:String,bytesTotal:int = -1,queueLimit:int = 1,inQueue:Boolean = true):QueueLoadOper
		{
			var loader:QueueLoadOper = new QueueLoadOper(assetBase);
			loader.useCurrentDomain = this.useCurrentDomain;
			loader.queueLimit = queueLimit;
			
			if (bytesTotal != -1)
				loader.setBytesTotal(bytesTotal);
					
			loader.loadResourcesFromXMLFile(filePath);
			
			if (progressBar)
			{
				if (loader.loadHelper.useRealTotalBytes)
				{
					loader.readyHandler = function ():void
					{
						progressBar.commitTargets(loader.children);
					}	
				}
				else
				{
					progressBar.commitTarget(loader);
				}
			}
			
			loader.addEventListener(OperationEvent.OPERATION_COMPLETE,loadCompleteHandler);
			if (inQueue)
				loader.commit(queue);
			else
				loader.execute();
			
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
		 * 将所有数据保存至ShareObject 
		 * @param version	版本号，为空则使用LoaderOper内的版本号
		 * 
		 */
		public function saveAllOperToShareObject(version:String = null):void
		{
			for each (var oper:LoadOper in oper)
				oper.saveToShareObject(version);
		}
		
		/**
		 * 对所有SWF文件执行unload
		 * 
		 */
		public function unloadAll():void
		{
			for each (var child:LoadOper in opers)
				child.unload();
		}
		
		/**
		 * 获得总数据大小 
		 */
		public function getTotalBytes():int
		{
			var t:int;
			for each (var child:LoadOper in opers)
				t += child.bytesTotal;
			
			return t;
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
		 * 创建一个Bitmap
		 * 
		 * @param ref
		 * @return 
		 * 
		 */
		public function getBitmap(ref:String):Bitmap
		{
			var cls:Class = this.getAssetByName(ref) as Class;
			return new cls() as Bitmap;
		}
		
		/**
		 * 创建一个BitmapData
		 * 
		 * @param ref
		 * @return 
		 * 
		 */
		public function getBitmapData(ref:String):BitmapData
		{
			var cls:Class = this.getAssetByName(ref) as Class;
			return new cls(0,0) as BitmapData;
		}
		
		/**
		 * 获得加载的非SWF资源
		 * 
		 * @param id	加载时指定的id，未指定则是文件路径
		 * @return 
		 * 
		 */
		public function getDataById(id:String):*
		{
			return getOper(id).data;
		}
	}
}