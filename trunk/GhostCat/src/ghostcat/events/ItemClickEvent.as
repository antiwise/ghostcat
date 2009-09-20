package ghostcat.events
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	
	/**
	 * 子对象点击事件
	 * @author flashyiyi
	 * 
	 */
	public class ItemClickEvent extends Event
	{
		public static const ITEM_CLICK:String = "item_click";
		
		public var item:*;
		
		public var relatedObject:InteractiveObject;
		
		public function ItemClickEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone() : Event
		{
			var evt:ItemClickEvent = new ItemClickEvent(type,bubbles,cancelable);
			evt.item = this.item;
			evt.relatedObject = this.relatedObject;
			return evt;
		}
	}
}