package ghostcat.manager
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import ghostcat.util.core.Singleton;
	
	/**
	 * 视图管理器。显示对象会按照类型被保存起来方便取出实例
	 * @author flashyiyi
	 * 
	 */
	public class ViewManager extends Singleton
	{ 
		static public function get instance():ViewManager
		{
			return Singleton.getInstance(ViewManager) as ViewManager;
		}
		
		static public function register(root:IEventDispatcher):void
		{
			var v:ViewManager = Singleton.create(ViewManager);
			v.register(root);
		}
		
		protected var root:IEventDispatcher;
		protected var dict:Dictionary;
		
		public function ViewManager()
		{
			super();
			
			this.dict = new Dictionary();
		}
		
		protected function register(root:IEventDispatcher):void
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
				root.removeEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
				root.removeEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler);
			}
		}
		
		protected function addToStageHandler(event:Event):void
		{
			var cls:* = event.target["constructor"];
			if (cls && !dict[cls])
				dict[cls] = event.target;
				
		}
		
		protected function removeFromStageHandler(event:Event):void
		{
			var cls:* = event.target["constructor"];
			if (cls && dict[cls] == event.target)
				delete dict[cls];
		}
		
		public function getView(cls:Class):DisplayObject
		{
			return dict[cls];
		}
	}
}