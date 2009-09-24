package ghostcat.events
{
	import flash.events.Event;
	
	/**
	 * 在ObjectProxy类里使用的属性变化事件
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class PropertyChangeEvent extends Event
	{
		/**
		 * 属性变化
		 */
		public static const PROPERTY_CHANGE:String = "property_change";
		
		public static function createUpdateEvent(source:Object,property:Object,oldValue:Object,newValue:Object):PropertyChangeEvent
		{
			var event:PropertyChangeEvent =new PropertyChangeEvent(PROPERTY_CHANGE);
			
			event.kind = "update";
			event.oldValue = oldValue;
			event.newValue = newValue;
			event.source = source;
			event.property = property;
			
			return event;
		}
		
		/**
		 * 类型，为update和delete其一
		 */
		public var kind:String;
		
		/**
		 * 新值
		 */
		public var newValue:Object;
		
		/**
		 * 旧值
		 */
		public var oldValue:Object;
		
		/**
		 * 属性
		 */
		public var property:Object;
		
		/**
		 * 源
		 */
		public var source:Object;
		
		public function PropertyChangeEvent(type:String, bubbles:Boolean = false,cancelable:Boolean = false,kind:String = null,
			property:Object = null, oldValue:Object = null,newValue:Object = null,source:Object = null)
		{
			super(type, bubbles, cancelable);
			
			this.kind = kind;
			this.property = property;
			this.oldValue = oldValue;
			this.newValue = newValue;
			this.source = source;
		}
		
		override public function clone():Event
		{
			return new PropertyChangeEvent(type, bubbles, cancelable, kind, property, oldValue, newValue, source);
		}
	}
	
}
