package ghostcat.util.core
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	/**
	 * 事件对象
	 * 
	 * @author flashyiyi
	 * 
	 */
	dynamic public class EventHandler extends Proxy
	{
		/**
		 * 事件列表 
		 */
		public var handlers:Object;
		
		/**
		 * 是否弱引用 
		 */
		public var useWeakReference:Boolean = false;
		
		public function EventHandler(obj:Object = null)
		{
			handlers = {};
			
			if (obj)
			{
				for (var key:String in obj)
					this[key] = obj[key];
			}
		}
		
		/**
		 * 增加一个事件 
		 * @param type
		 * @param listener
		 * @param useCapture
		 * @param priority
		 * @param useWeakReference
		 * 
		 */
		public function add(type:String,listener:Function,useCapture:Boolean = false,priority:int = 0,useWeakReference:Boolean = false):void
		{
			if (this.useWeakReference)
				useWeakReference = true;
			
			var h:HandlerItem = new HandlerItem();
			h.type = type;
			h.listener = listener;
			h.useCapture = useCapture;
			h.priority = priority;
			h.useWeakReference = useWeakReference;
			
			this.handlers[type] = h;
		}
		
		/**
		 * 向一个目标添加事件 
		 * @param target
		 * 
		 */
		public function parse(target:EventDispatcher):void
		{
			for each (var handler:HandlerItem in handlers)
				target.addEventListener(handler.type,handler.listener,handler.useCapture,handler.priority,handler.useWeakReference);
		}
		
		/**
		 * 取消目标的事件 
		 * @param target
		 * 
		 */
		public function unparse(target:EventDispatcher):void
		{
			for each (var handler:HandlerItem in handlers)
				target.removeEventListener(handler.type,handler.listener);
		}
		
		/**
		 * 复制 
		 * @return 
		 * 
		 */
		public function clone():EventHandler
		{
			var e:EventHandler = new EventHandler();
			if (this.handlers)
			{
				for (var key:String in this.handlers)
					e.handlers[key] = this.handlers[key];
			}
			e.useWeakReference = this.useWeakReference;
			return e;
		}
		
		flash_proxy override function setProperty(property:*,value:*):void 
		{
			add(property,value);
		}
		
		flash_proxy override function getProperty(property:*):* 
		{
			return (handlers[property] as HandlerItem).listener as Object;
		}
	}
}

class HandlerItem
{
	public var type:String;
	public var listener:Function;
	public var useCapture:Boolean = false;
	public var priority:int = 0;
	public var useWeakReference:Boolean = false;
}