package ghostcat.manager
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import ghostcat.util.Util;
	import ghostcat.util.core.Singleton;
	
	/**
	 * 视图管理器。显示对象会按照类型被保存起来方便取出实例
	 * @author flashyiyi
	 * 
	 */
	public class ViewManager extends Singleton
	{ 
		static private var _instance:ViewManager;
		static public function get instance():ViewManager
		{
			return _instance;
		}
		
		static public function register(root:IEventDispatcher):void
		{
			if (!_instance)
			{
				_instance = new ViewManager();
				_instance.register(root);
			}
		}
		
		protected var root:IEventDispatcher;
		protected var dict:Dictionary;
		
		/**
		 * 是否允许一个类对应多个实例
		 */
		public var multi:Boolean;
		
		/**
		 * 加入舞台的回调函数
		 */
		public var addToStageFunction:Function;
		
		/**
		 * 移出舞台的回调函数
		 */
		public var removeFromStageFunction:Function;
		
		public function ViewManager()
		{
			super();
			
			this.dict = new Dictionary();
		}
		
		/**
		 * 注册
		 * 
		 * @param root	文档类
		 * @param multi	是否允许一个类对应多个实例
		 * 
		 */
		protected function register(root:IEventDispatcher,multi:Boolean = false):void
		{
			if (this.root)
				unregister();
			
			this.root = root;
			this.root.addEventListener(Event.ADDED_TO_STAGE,addToStageHandler,true);
			this.root.addEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler,true);
		}
		
		public function unregister():void
		{
			if (root)
			{
				root.removeEventListener(Event.ADDED_TO_STAGE,addToStageHandler,true);
				root.removeEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler,true);
			}
		}
		
		protected function addToStageHandler(event:Event):void
		{
			var cls:* = event.target["constructor"];
			if (cls)
			{ 
				var list:Array = dict[cls];
				if (multi)
				{
					if (!list)
						dict[cls] = list = [];
					
					list.push(event.target);	
					
					if (addToStageFunction != null)
						addToStageFunction(event.target);
				}
				else
				{
					if (!list) //单例模式只保持第一个加入的实例
					{
						dict[cls] = [event.target];
						
						if (addToStageFunction != null)
							addToStageFunction(event.target);
					}
				}
			}	
		}
		
		protected function removeFromStageHandler(event:Event):void
		{
			var cls:* = event.target["constructor"];
			if (cls)
			{
				var list:Array = dict[cls];
				if (list)
				{
					if (multi)
					{
						Util.remove(list,event.target);
						if (list.length == 0)
						{
							delete dict[cls];
							
							if (removeFromStageFunction != null)
								removeFromStageFunction(event.target);
						}
					}
					else
					{
						if (list[0] == event.target)
						{
							delete dict[cls];
							
							if (removeFromStageFunction != null)
								removeFromStageFunction(event.target);
						}
					}
				}
			}
		}
		
		/**
		 * 取出实例 
		 * @param cls	类
		 * @param filter	过滤对象
		 * @return 
		 * 
		 */
		public function getView(cls:Class,filter:Object = null):DisplayObject
		{
			var list:Array = dict[cls];
			if (!list)
				return null;
			
			if (filter && multi)
			{
				for each (var v:Object in list)
				{
					var match:Boolean = true;
					for (var p:String in filter)
					{
						if (!(v.hasOwnProperty(p) && v[p] == filter[p]))
						{
							match = false;
							break;
						}
					}
					if (match)
						return v as DisplayObject;
				}
			}
			else
			{
				return list[0];
			}
			return null;
		}
	}
}