package ghostcat.events
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	
	/**
	 * 树对象事件
	 * @author flashyiyi
	 * 
	 */
	public class TreeEvent extends Event
	{
		public static const TREE_CLICK:String = "tree_click";
		public static const TREE_CLOSE:String = "tree_close";
		public static const TREE_OPEN:String = "tree_open";
		public static const TREE_OPENING:String = "tree_opening";
		
		public var data:*;
		
		public var relatedObject:InteractiveObject;
		
		public function TreeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone() : Event
		{
			var evt:TreeEvent = new TreeEvent(type,bubbles,cancelable);
			evt.data = this.data;
			evt.relatedObject = this.relatedObject;
			return evt;
		}
		
		public static function createTreeEvent(type:String,data:*,relatedObject:InteractiveObject):TreeEvent
		{
			var e:TreeEvent = new TreeEvent(type,false,type == TREE_OPENING);
			e.data = data;
			e.relatedObject = relatedObject;
			return e;
		}
	}
}