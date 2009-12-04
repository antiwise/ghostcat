package ghostcat.manager
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import ghostcat.debug.Debug;
	import ghostcat.events.OperationEvent;
	import ghostcat.operation.LoadOper;
	import ghostcat.operation.LoadTextOper;
	import ghostcat.operation.Oper;
	import ghostcat.operation.Queue;
	import ghostcat.ui.controls.GProgressBar;
	import ghostcat.util.core.Singleton;

	/**
	 * 资源管理类
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class AssetManager extends Singleton
	{
		static public function get instance():AssetManager
		{
			return Singleton.getInstanceOrCreate(AssetManager) as AssetManager;
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
		 * 加载时显示的图标 
		 */
		public var loadIcon:Class;
		
		/**
		 * 加载错误时显示的图标
		 */
		public var errorIcon:Class;
		
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
		 * 载入一个资源
		 * 
		 * @param res	资源路径
		 * @param name	资源的名称，用于在进度条中显示
		 * @return 
		 * 
		 */
		public function loadResource(res:String,name:String=null):Oper
		{
			var oper:LoadOper = new LoadOper(assetBase + res);
			if (name)
				oper.name = name;
			
			oper.addEventListener(OperationEvent.OPERATION_START,changeProgressTargetHandler);
			oper.addEventListener(OperationEvent.OPERATION_COMPLETE,loadCompleteHandler);
			
			oper.commit(queue);
			return oper;
		}
		
		//获得加载资源数组
		private function getResources(res:Array,names:Array=null):Array
		{
			var list:Array = [];
			for (var i:int = 0;i < res.length;i++)
			{
				var oper:LoadOper = new LoadOper(assetBase + res[i]);
				if (names && names[i])
					oper.name = names[i];
				
				oper.addEventListener(OperationEvent.OPERATION_START,changeProgressTargetHandler);
				oper.addEventListener(OperationEvent.OPERATION_COMPLETE,loadCompleteHandler);
				
				list.push(oper);
			}
			return list;
		}
		
		private function changeProgressTargetHandler(event:OperationEvent):void
		{
			if (progressBar)
				progressBar.target = (event.oper as LoadOper).eventDispatcher;
		}
		
		private function loadCompleteHandler(event:OperationEvent):void
		{
			var oper:Oper = event.oper;
			if (oper.name)
				opers[oper.name] = oper;
			
			oper.removeEventListener(OperationEvent.OPERATION_START,changeProgressTargetHandler);
			oper.removeEventListener(OperationEvent.OPERATION_COMPLETE,loadCompleteHandler);
		}
		
		/**
		 * 批量载入资源
		 * 
		 * @param res	资源路径列表
		 * @param names 资源的名称，用于在进度条中显示
		 * @return 
		 * 
		 */
		public function loadResources(res:Array,names:Array=null):Queue
		{
			var subQueue:Queue = new Queue(getResources(res,names));
			subQueue.commit(queue);
			return subQueue;
		}
		
		/**
		 * 先读取一个XML配置文件，再根据配置文件的内容批量载入资源。
		 * Oper的名称将是配置文件的@name属性，地址则是@url属性。
		 * 
		 * @param filePath	资源配置文件名称
		 * @return 
		 * 
		 */
		public function loadResourcesFromXMLFile(filePath:String):Queue
		{
			var subQueue:Queue = new Queue();
			var oper:LoadTextOper = new LoadTextOper(assetBase + filePath,null,false,resConfigHandler);
			oper.commit(queue);
			subQueue.commit(queue);
			
			return subQueue;
			
			function resConfigHandler(event:OperationEvent):void
			{
				var xml:XML = new XML((event.oper as LoadTextOper).data);
				var res:Array = [];
				var names:Array = [];
				for each (var child:XML in xml.children())
				{
					res.push(child.@url.toString());
					names.push(child.@name.toString());
				}
				subQueue.children = getResources(res,names);
			}
		}
		
		
		/**
		 * 根据载入时的名称获取加载器，继而可以取得加载完成的资源
		 *  
		 * @param name
		 * @return 
		 * 
		 */
		public function getOper(name:String):LoadOper
		{
			return opers[name];
		}
		
		/**
		 * 删除载入的资源。只有这样做才能回收用loadResource加载的资源。
		 * 
		 * @param name
		 * @return 
		 * 
		 */
		public function deleteOper(name:String):Boolean
		{
			return (delete opers[name]);
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
			return getAssetByName(ref)() as MovieClip;
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
			return getAssetByName(ref)() as Sprite;
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
			return getAssetByName(ref)(width,height) as BitmapData;
		}
	}
}