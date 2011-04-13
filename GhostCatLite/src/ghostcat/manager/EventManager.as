package ghostcat.manager
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * 事件管理类。使用此类代理进行监听以及销毁可确保事件能够被移除。
	 * 
	 * AS3的事件管理是一个很基本的能力，不建议在这样的地方消耗多余的性能，除非必要否则请不要使用此类。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class EventManager
	{
		static private var events:Dictionary=new Dictionary(true);
		
		/**
		 * 获得一个对象的所有事件
		 * 
		 * @param obj
		 * @return 
		 * 
		 */
		static public function getEvents(obj:EventDispatcher):Array
		{
			return events[obj];
		}
		
		/**
		 * 添加事件
		 * 
		 * @param obj	监听器
		 * @param type	事件类型
		 * @param listener	事件函数
		 * @param autoRemove	是否在移出显示列表的时候自动卸除事件
		 * 
		 */
		static public function addEventListener(obj:EventDispatcher,type:String,listener:Function,autoRemove:Boolean=false):void
		{
			obj.addEventListener(type,listener);
			if (events[obj] == null)
			{
				events[obj] = [];
				if (obj is DisplayObject) 
					obj.addEventListener(Event.REMOVED_FROM_STAGE,autoRemoveHandler);
			}
			(events[obj] as Array).push(new EventItem(type,listener,autoRemove));
		}
		
		/**
		 * 卸除事件
		 * 
		 * @param obj	监听器
		 * @param type	事件类型，为空则为不限定类型
		 * @param listener	事件监听器，为空则为不限定监听器。两者皆为空则会卸除监听器的所有事件
		 * @param onlyAutoRemove	是否只卸除允许自动卸除的事件
		 * 
		 */
		static public function removeEventListener(obj:EventDispatcher,type:String=null,listener:Function=null,onlyAutoRemove:Boolean=false):void
		{
			var arr:Array=events[obj] as Array;
			if (!arr)
				return;
				
			for (var i:int = arr.length - 1;i>=0;i--)
			{
				var eventItem:EventItem = arr[i] as EventItem;
				if ((type == null || type == eventItem.type) &&
					(listener == null || listener == eventItem.listener) &&
					(!onlyAutoRemove || eventItem.autoRemove))
				{
					obj.removeEventListener(eventItem.type,eventItem.listener);
					arr.splice(i,1);
				}
			}
			if (arr.length==0)
			{
				if (obj is DisplayObject)
					obj.removeEventListener(Event.REMOVED_FROM_STAGE,autoRemoveHandler);
				
				delete events[obj];
			}
		}
		
		/**
		 * 销毁对象
		 *  
		 * @param obj	对象
		 * @param child	是否销毁子对象
		 * 
		 */
		static public function destory(obj:EventDispatcher,child:Boolean=true):void
		{
			removeEventListener(obj);
			
			var displayObj:DisplayObject = obj as DisplayObject;
			if (!displayObj)
				return;
			
			if (displayObj is Bitmap)
				(displayObj as Bitmap).bitmapData.dispose();
			
			if (displayObj is DisplayObjectContainer)
			{
				if (child)
				{
					while ((displayObj as DisplayObjectContainer).numChildren)
						destory((displayObj as DisplayObjectContainer).getChildAt(0),true);
				}
			}
			
			if (displayObj.parent)
				displayObj.parent.removeChild(displayObj);
		}
		
		static private function autoRemoveHandler(event:Event):void
		{
			var obj:DisplayObject=event.currentTarget as DisplayObject;
			obj.removeEventListener(Event.REMOVED_FROM_STAGE,autoRemoveHandler);
			
			removeEventListener(obj,null,null,true); 
		}
	}
}
class EventItem
{
	public var type:String;
	public var listener:Function;
	public var autoRemove:Boolean;
	
	public function EventItem(type:String,listener:Function,autoRemove:Boolean)
	{
		this.type = type;
		this.listener = listener;
		this.autoRemove = autoRemove;
	}
}