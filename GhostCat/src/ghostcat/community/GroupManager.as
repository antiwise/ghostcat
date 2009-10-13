package ghostcat.community
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import ghostcat.util.Util;
	
	/**
	 * 一组对象的管理
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GroupManager extends EventDispatcher
	{
		/**
		 * 执行的函数
		 */		
		public var command:Function;
		
		/**
		 * 数据
		 */		
		public var data:Array = [];
		
		/**
		 * 过滤函数，参数为对象，返回值为是否可用的布尔值
		 */		
		public var filter:Function;
		
		/**
		 * 限制进行遍历的首对象，但不限制这个对象对其他对象的二次遍历
		 * 
		 */		
		public var onlyCheckValues:Array;
		
		/**
		 * 记录需要计算的对象
		 */
		protected var dirtys:Dictionary
		
		private var _setDirtyWhenEvent:String;//记录自动监听的变化事件
		
		/**
		 * 当对象发生某个事件时，会自动触发setDirty方法。
		 * 
		 */
		public function set setDirtyWhenEvent(event:String):void
		{
			for (var i:int = 0; i < data.length;i++)
				registerDirty(data[i],event);
			
			_setDirtyWhenEvent = event;
		}
		
		public function get setDirtyWhenEvent():String
		{
			return _setDirtyWhenEvent;
		}
		
		/**
		 * 注册一个事件，对象发生事件会自动执行setDirty
		 *  
		 * @param v
		 * @param event
		 * 
		 */
		public function registerDirty(v:EventDispatcher,event:String):void
		{
			if (event)
			{
				if (v && !v.hasEventListener(event))
					v.addEventListener(event,dirtyHandler);
			}
			else
				unregisterDirty(v,setDirtyWhenEvent);
		}
		
		/**
		 * 删除已经注册的事件
		 * 
		 * @param v
		 * @param event
		 * 
		 */
		public function unregisterDirty(v:EventDispatcher,event:String):void
		{
			if (v && event && v.hasEventListener(event))
				v.removeEventListener(event,dirtyHandler);
		}
		
		/**
		 * 设置dirty的方法
		 * @param event
		 * 
		 */
		protected function dirtyHandler(event:Event):void
		{
			dirtys[event.target] = true;
		}
		
		/**
		 * 在calculateAll参数为true时，只有先执行此方法才会执行。此属性执行一次后就会失效。
		 * 
		 */
		public function setDirty(v:*):void
		{
			dirtys[v] = true;
		}
		
		/**
		 * 
		 * @param command	带一个参数的函数
		 * 
		 */
		public function GroupManager(command:Function)
		{
			this.command = command;
			dirtys = new Dictionary();
		}
		
		/**
		 * 计算
		 * 
		 * @param v	数据
		 * 
		 */				
		public function calculate(v:*):void
		{
			command(v);
		}
		
		/**
		 * 让全部数据都执行一次函数
		 * 
		 * @param filter	是否只遍历已经注册变化的对象。设为true时，只有执行过setDirty()方法的对象会被遍历
		 * 
		 */		
		public function calculateAllOnce(onlyFilter:Boolean = false):void
		{
			for (var i:int = 0; i < data.length;i++)
			{
				var v:* = data[i];
				if ((!onlyFilter || dirtys[v]) && !(filter!=null && filter(v)==false))
					command(v);
				
			}
			dirtys = new Dictionary();
		}
		
		/**
		 * 增加
		 * 
		 * @param obj	对象
		 * 
		 */		
		public function add(obj:*):void
		{
			data.push(obj);
			
			if (obj is EventDispatcher && setDirtyWhenEvent)
				registerDirty(obj,setDirtyWhenEvent);
			
//			calculate(obj);//加入时立即计算
		}
		
		/**
		 * 删除
		 * 
		 * @param obj	对象
		 * 
		 */		
		public function remove(obj:*):void
		{
			Util.remove(data,obj);
			
			if (obj is EventDispatcher && setDirtyWhenEvent)
				unregisterDirty(obj,setDirtyWhenEvent);
			
			delete dirtys[obj];
		}
		
		/**
		 * 添加一个显示对象的所有子对象
		 * 
		 * @param target
		 * 
		 */
		public function addAllChildren(target:DisplayObjectContainer):void
		{
			for (var i:int = 0;i < target.numChildren;i++)
				add(target.getChildAt(i));
		}
		
		/**
		 * 删除一个显示对象的所有子对象
		 * 
		 * @param target
		 * 
		 */
		public function removeAllChildren(target:DisplayObjectContainer):void
		{
			for (var i:int = 0;i < target.numChildren;i++)
				remove(target.getChildAt(i));
		}
	}
}