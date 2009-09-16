package ghostcat.util
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import ghostcat.events.PropertyChangeEvent;
	
	/**
	 * 改变对象属性时将会触发事件
	 * 
	 * @author flashyiyi
	 * 
	 */
	dynamic public class ObjectProxy extends Proxy implements IEventDispatcher
	{
		private var eventDispather:EventDispatcher;
		private var source:*;
		
		public function ObjectProxy(o:Object)
		{
			this.source = o;
			this.eventDispather = new EventDispatcher();
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			eventDispather.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			eventDispather.removeEventListener(type,listener,useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return eventDispather.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return eventDispather.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return eventDispather.willTrigger(type);
		}
		
		flash_proxy override function callProperty(methodName:*, ...args):*
		{
			var metrod:* = source[methodName];
			(metrod as Function).apply(null,args);
		}
		
		flash_proxy override function getProperty(property:*):* 
		{
			return source[property];
		}
		
		flash_proxy override function setProperty(property:*,value:*):void 
		{
			var oldValue:* = source[property];
			source[property] = value;
			
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,
				false,false,"update",
				property,oldValue,value,this))
		}
		
		flash_proxy override function deleteProperty(property:*):Boolean 
		{
			var oldValue:* = source[property];
			var s:Boolean = delete(source[property]);
			
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,
				false,false,"delete",
				property,oldValue,null,this))
		
			return s;
		}
	}
}