package org.ghostcat.display.loader
{
	import flash.utils.getDefinitionByName;
	
	import org.ghostcat.display.GSprite;
	import org.ghostcat.events.OperationEvent;
	import org.ghostcat.manager.AssetManager;
	import org.ghostcat.operation.FunctionOper;
	import org.ghostcat.operation.LoadOper;
	import org.ghostcat.operation.Oper;
	import org.ghostcat.operation.Queue;
	import org.ghostcat.util.Handler;

	/**
	 * 动态加载SWF模块
	 * 
	 * 依赖于AssetManager类，请参照此类说明使用。
	 * 
	 * @see org.ghostcat.manager.AssetManager
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class AssetLoader extends org.ghostcat.display.GSprite
	{
		/**
		 * AssetLoader的独立加载队列
		 */		
		public static var assetQueue:Queue = new Queue();
		
		/**
		 * 资源的类名
		 */		
		public var ref:String;
		
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
		
		private var handlers:Array = [];//加载完成函数
		private var loader:Oper;//加载器
			
		public function AssetLoader()
		{
			super();
			this.acceptContentPosition = false;
		}
		
		protected override function init():void
		{
			super.init();
			
			load();
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
				url = AssetManager.instance.getDefaultFilePath(ref);//未设置路径则取默认路径
				
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
		
		public override function destory():void
		{
			super.destory();
			handlers = [];
			
			if (loader)
				loader.halt();
		}
	}
}