package ghostcat.operation.load
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import ghostcat.events.OperationEvent;
	import ghostcat.operation.LoadOper;
	import ghostcat.operation.LoadTextOper;
	import ghostcat.operation.Oper;
	import ghostcat.operation.ParallelOper;
	import ghostcat.operation.Queue;
	import ghostcat.text.URL;
	import ghostcat.ui.controls.IProgressTargetClient;
	import ghostcat.util.Util;
	import ghostcat.util.load.GroupLoaderHelper;
	
	/**
	 * 队列加载 
	 * @author flashyiyi
	 * 
	 */
	public class QueueLoadOper extends ParallelOper implements IProgressTargetClient
	{
		private var _name:String;
		
		/**
		 * 资源加载的基本地址
		 */
		public var assetBase:String = "";
		
		/**
		 * 资源列表 
		 */
		public var opers:Dictionary;
		
		/**
		 * 加载信息 
		 */
		public var loadHelper:GroupLoaderHelper;
		
		/**
		 * 加载XML文本的Oper
		 */
		public var resConfigOper:LoadTextOper;
		
		/**
		 * 获得文件列表时的回调 
		 */
		public var readyHandler:Function;
		
		/**
		 * 名称
		 */
		public function get name():String
		{
			return _name;
		}
		
		public function set name(v:String):void
		{
			_name = v;
		}
		
		/**
		 * 对外事件发送者 
		 * @return 
		 * 
		 */
		public function get eventDispatcher():IEventDispatcher
		{
			return loadHelper;
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
		
		public function QueueLoadOper(assetBase:String = "")
		{
			super();
			
			this.assetBase = assetBase;
			this.opers = new Dictionary();
			this.loadHelper = new GroupLoaderHelper();
		}
		
		/**
		 * 设置文件总大小 
		 * @param v
		 * 
		 */
		public function setBytesTotal(v:int):void
		{
			loadHelper.bytesTotal = v;
		}
		
		/**
		 * 当前正在加载的LoadOper 
		 * @return 
		 * 
		 */
		public function get currentChild():LoadOper
		{
			return (running && running.length > 0) ? running[0] : null;
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
		public function loadResources(res:Array,ids:Array=null,names:Array = null):void
		{
			var list:Array = [];
			for (var i:int = 0;i < res.length;i++)
			{
				var oper:LoadOper = new LoadOper(getFullUrl(res[i]));
				oper.addEventListener(OperationEvent.OPERATION_START,operStartHandler);
				
				if (ids && ids[i])
				{
					oper.id = ids[i];
					opers[oper.id] = oper;
				}
				
				if (names && names[i])
				{
					oper.name = names[i];
				}
				
				list.push(oper);
			}
			
			this.children = list;
		}
		
		private function operStartHandler(event:OperationEvent):void
		{
			event.oper.removeEventListener(OperationEvent.OPERATION_START,operStartHandler);
			loadHelper.addLoader((event.oper as LoadOper).eventDispatcher);
		}
		
		/**
		 * 先读取一个XML配置文件，再根据配置文件的内容批量载入资源。
		 * Oper的名称将是配置文件的@id属性，地址则是@url属性，资源名称是@tip属性。
		 * 
		 * 加载结束可监听返回值的operation_complete事件
		 * 
		 * @param filePath	资源配置文件名称
		 * @param readyHandler 获得加载文件列表时的回调
		 * @return 
		 * 
		 */
		public function loadResourcesFromXMLFile(filePath:String,readyHandler:Function = null):void
		{
			this.resConfigOper = new LoadTextOper(getFullUrl(filePath),null,false,resConfigHandler,fault);
			this.readyHandler = readyHandler;
		}
		
		protected	function resConfigHandler(event:OperationEvent):void
		{
			var xml:XML = new XML((event.oper as LoadTextOper).data);
			var res:Array = [];
			var ids:Array = [];
			var names:Array = [];
			for each (var child:XML in xml.children())
			{
				res.push(child.@url.toString());
				ids.push(child.@id.toString());
				names.push(child.@tip.toString())
			}
			
			resConfigOper = null;
			
			loadResources(res,ids,names);
			
			if (readyHandler != null)
				readyHandler();
			
			super.execute();
		}
		
		public override function execute():void
		{
			if (resConfigOper)
				resConfigOper.execute();
			else
				super.execute();
		}
	}
}