package ghostcat.util
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import ghostcat.events.PropertyChangeEvent;
	
	[Event(name="property_change",type="ghostcat.events.PropertyChangeEvent")]
	
	/**
	 * 改变对象属性时将会触发事件
	 * 
	 * @author flashyiyi
	 * 
	 */
	dynamic public class ObjectProxy extends Proxy implements IEventDispatcher
	{
		private var eventDispather:EventDispatcher;
		
		/**
		 * 原值 
		 */
		public var data:*;
		
		public function ObjectProxy(o:Object)
		{
			this.data = o;
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
			var metrod:* = data[methodName];
			(metrod as Function).apply(null,args);
		}
		
		flash_proxy override function getProperty(property:*):* 
		{
			return data[property];
		}
		
		flash_proxy override function setProperty(property:*,value:*):void 
		{
			var oldValue:* = data[property];
			data[property] = value;
			
			if (oldValue && oldValue is IEventDispatcher)
				(oldValue as IEventDispatcher).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,propertyChangeHandler);
			
			if (value && value is IEventDispatcher)
				(value as IEventDispatcher).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,propertyChangeHandler);
			
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,
				false,false,"update",
				property,oldValue,value,this))
		}
		
		flash_proxy override function deleteProperty(property:*):Boolean 
		{
			var oldValue:* = data[property];
			var s:Boolean = delete(data[property]);
			
			if (oldValue && oldValue is IEventDispatcher)
				(oldValue as IEventDispatcher).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,propertyChangeHandler);
			
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,
				false,false,"delete",
				property,oldValue,null,this))
		
			return s;
		}
		
		protected function propertyChangeHandler(event:PropertyChangeEvent):void
		{
			var property:*;
			for (var key:* in data)
			{
				var item:ObjectProxy = data[key];
				if (item && item.eventDispather == event.target)
				{
					property = key;
					break;
				}
			}
			
			var value:* = data[property];
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,
				false,false,"update",
				property,value,value,this))
		}
	}
}