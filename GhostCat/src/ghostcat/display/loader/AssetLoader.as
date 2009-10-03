package ghostcat.display.loader
{
	import flash.utils.getDefinitionByName;
	
	import ghostcat.display.GSprite;
	import ghostcat.events.OperationEvent;
	import ghostcat.manager.AssetManager;
	import ghostcat.operation.FunctionOper;
	import ghostcat.operation.LoadOper;
	import ghostcat.operation.Oper;
	import ghostcat.operation.Queue;
	import ghostcat.util.core.Handler;

	/**
	 * 动态加载SWF模块
	 * 
	 * 部分依赖于AssetManager类。
	 * 
	 * @see ghostcat.manager.AssetManager
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class AssetLoader extends GSprite
	{
		/**
		 * AssetLoader的独立加载队列
		 */		
		public static var assetQueue:Queue = new Queue();
		
		/**
		 * 通过类名来获得默认文件地址。地址始终是小写。
		 * 这个方法用于动态加载。可以同样利用jsfl将库中的类按类名分散到各个文件里（这个jsfl已经提供），
		 * 分散到目录的文件更容易管理，且不容易出现重名。
		 * 大量动态资源可以先在一个FLA中编辑再散开，然后在AssetLoader可直接通过包名加载。
		 * 
		 * @param ref	类名
		 * @param fileName	指定文件名
		 * @return 
		 * 
		 */		
		public function getDefaultFilePath(ref:String,fileName:String=null):String
		{
			var names:Array = ref.split("::");
			var url:String;
			if (names.length == 2)
			{
				if (fileName)
					names[1] = fileName;
				names[0] = (names[0] as String).replace(/\./g,"/");
				url = names.join("/").toLowerCase();
			}
			else
			{
				if (fileName)
					names[0] = fileName;
				url = (names[0] as String).toLowerCase();
			}
			return AssetManager.instance.assetBase + url + ".swf";
		}
		
		
		private var _ref:String;
		private var handlers:Array = [];//加载完成函数
		private var loader:Oper;//加载器
			
		/**
		 * 资源的类名
		 */		
		public function get ref():String
		{
			return _ref;
		}

		public function set ref(v:String):void
		{
			_ref = v;
			load();
		}

		/**
		 * 资源的类实例
		 */
		public var cls:Class;
		
		/**
		 * 下载路径，否则根据包名和类名获得路径
		 */		
		public var url:String;
		
		/**
		 * 下载是否进入队列
		 */		
		public var queue:Boolean = false;
		
		public function AssetLoader(ref:String=null)
		{
			super();
			
			this.acceptContentPosition = false;
		
			if (ref)
				this.ref = ref;
		}
		
		/**
		 * 加载
		 */		
		public function load():void
		{
			var c:Class = AssetManager.instance.loadIcon;
			if (c)
				setContent(new c());
			
			if (url==null)
				url = getDefaultFilePath(ref);//未设置路径则取默认路径
				
			cls = null;
			try
			{
				cls = getDefinitionByName(ref) as Class;
			}
			catch (e:Error){};
			
			if (!cls)
				loader = new LoadOper(url,null,rhander,fhander);
			else
				loader = new FunctionOper(rhander);//如果已经加载过了，就直接取值而不再次加载
			
			(queue)?loader.commit(assetQueue):loader.execute();
		}
		
		private function rhander(event:OperationEvent):void
		{
			if (!cls)
				cls = AssetManager.instance.getAssetByName(ref);
			
			var c:Class = cls;
			if (c)
				setContent(new c());
			
			doHandler();
		}
		
		private function fhander(event:OperationEvent):void
		{
			var c:Class = AssetManager.instance.errorIcon;
			if (c)
				setContent(new c());
		}
		
		/**
		 * 增加一个加载完成后执行的函数
		 * 
		 * @param caller	调用者
		 * @param handler	函数
		 * @param para	参数
		 * 
		 */
		public function addHandler(handler:Function,para:Array=null,caller:*=null):void
		{
			handlers.push(new Handler(handler,para,caller));
		}
		
		/**
		 * 立即执行所有函数
		 */
		public function doHandler():void
		{
			for (var i:int=0;i<handlers.length;i++)
				(handlers[i] as Handler).call();
		}
		/** @inheritDoc*/
		public override function destory():void
		{
			super.destory();
			handlers = [];
			
			if (loader)
				loader.halt();
		}
	}
}