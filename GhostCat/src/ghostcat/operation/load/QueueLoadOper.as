package ghostcat.operation.load
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import ghostcat.debug.Debug;
	import ghostcat.events.OperationEvent;
	import ghostcat.operation.Oper;
	import ghostcat.operation.ParallelOper;
	import ghostcat.operation.Queue;
	import ghostcat.ui.controls.IProgressTargetClient;
	import ghostcat.util.Util;
	import ghostcat.util.load.GroupLoaderHelper;
	import ghostcat.util.text.URL;
	
	/**
	 * 队列加载 
	 * @author flashyiyi
	 * 
	 */
	public class QueueLoadOper extends ParallelOper implements IProgressTargetClient
	{
		/**
		 * 资源加载的基本地址
		 */
		public var assetBase:String = "";
		
		/**
		 * 是否加载到同域 
		 */
		public var useCurrentDomain:Boolean = true;
		
		/**
		 * 资源列表 
		 */
		public var opers:Array = [];
		
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
			return currentChild ? currentChild.name : null;
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
		
		public function QueueLoadOper(assetBase:String = "",queueLimit:int = 1,rhandler:Function=null,fhandler:Function=null)
		{
			super();
			
			this.autoStart = false;
			this.assetBase = assetBase;
			this.queueLimit = queueLimit;
			this.loadHelper = new GroupLoaderHelper();
			
			if (rhandler!=null)
				this.addEventListener(OperationEvent.OPERATION_COMPLETE,rhandler);
			
			if (fhandler!=null)
				this.addEventListener(OperationEvent.OPERATION_ERROR,fhandler);
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
		 * @param ids 资源的ID
		 * @param names 资源的名称，用于在进度条中显示
		 * 
		 * 加载结束可监听返回值的operation_complete事件
		 * @return 
		 * 
		 */
		public function loadResources(res:Array,ids:Array=null,names:Array = null,sizes:Array = null):void
		{
			for (var i:int = 0;i < res.length;i++)
			{
				var oper:LoadOper = new LoadOper(getFullUrl(res[i]));
				oper.useCurrentDomain = this.useCurrentDomain;
				loadHelper.addLoader(oper);
				
				if (ids && ids[i])
					oper.id = ids[i];
				else
					oper.id = res[i];
				
				if (names && names[i])
					oper.name = names[i];
				else
					oper.name = oper.id;
				
				if (sizes && sizes[i])
					loadHelper.addBytesTotal(sizes[i]);
				
				this.opers.push(oper);
				this.commitChild(oper);
			}
		}
		
		public function loadResourcesFromXMLList(xml:XMLList):void
		{
			var res:Array = [];
			var ids:Array = [];
			var names:Array = [];
			var sizes:Array = [];
			for each (var child:XML in xml)
			{
				res.push(child.@url.toString());
				ids.push(child.@id.toString());
				sizes.push(int(child.@size));
				var name:String = child.@name.toString();
				if (!name)
					name = child.@tip.toString()
				names.push(name)
			}
			loadResources(res,ids,names,sizes);
		}
		
		/**
		 * 先读取一个XML配置文件，再根据配置文件的内容批量载入资源。
		 * Oper的名称将是配置文件的@id属性，地址则是@url属性，资源名称是@tip或者@name属性。
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
			resConfigOper = null;
			
			var xml:XML = new XML((event.oper as LoadTextOper).data);
			loadResourcesFromXMLList(xml.children());
			
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
		
		public override function result(event:*=null):void
		{
			Debug.trace("LOAD","QueueLoadOper Complete: " + loadHelper.realBytesTotal)
			super.result(event);
		}
	}
}