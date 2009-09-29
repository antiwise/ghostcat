package ghostcat.community
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import ghostcat.util.Util;
	
	/**
	 * 群聚实现基类
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class CommunityManager extends EventDispatcher
	{
		/**
		 * 数据
		 */		
		public var data:Array = [];
		
		/**
		 * 执行的函数。此函数应当有两个参数，对应两个对象。可以将第二个参数设置为可选值。
		 */		
		public var command:Function;
		
		/**
		 * 过滤函数，参数为对象，返回值为是否可用的布尔值
		 */		
		public var filter:Function;
		
		/**
		 * 限制进行遍历的首对象，但不限制这个对象对其他对象的二次遍历
		 * 
		 */		
		public var onlyCheckValues:Array;
		
		
		
		
		
		
		private var _setDirtyWhenEvent:String;//记录自动监听的变化事件
		private var dirtys:Dictionary;//记录需要计算的对象
		
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
		
		private function dirtyHandler(event:Event):void
		{
			setDirty(event.target);
		}
		
		/**
		 * 在calculateAll参数为true时，只有先执行此方法才会执行。此属性执行一次后就会失效。
		 * 
		 */
		public function setDirty(v:*):void
		{
			dirtys[v] = true;
		}
		
		
		public function CommunityManager(command:Function)
		{
			this.command = command;
			
			dirtys = new Dictionary();
		}
		
		/**
		 * 多对多重复遍历所有内容一次
		 * 
		 * @param filter	是否只遍历已经注册变化的对象。设为true时，只有执行过setDirty()方法的对象会被遍历
		 * 
		 */
		public function calculateAll(filter:Boolean = true):void
		{
			var values:Array = data;
			if (onlyCheckValues)
				values = onlyCheckValues;
			
			for (var i:int = 0; i < values.length;i++)
			{
				var v:* = values[i];
				if ((!filter || dirtys[v]) && needCalculate(v))
				{
					delete dirtys[v];
					calculate(v);
				}
			}
			
		}
		
		/**
		 * 一对多单独遍历一个对象
		 * 
		 * @param v	数据
		 * 
		 */				
		public function calculate(v:*):void
		{
			if (!needCalculate(v))
				return;
			
			for (var i:int = 0; i < data.length;i++)
			{
				var v2:* = data[i];
				if (v != v2 && needCalculate(v2))
					command(v,v2);
			}
		}
		
		protected function needCalculate(v:*):Boolean
		{
			return !(filter!=null && filter(v)==false);
		}
		
		/**
		 * 让全部数据都执行一次函数
		 * 
		 * @param filter	是否只遍历已经注册变化的对象。设为true时，只有执行过setDirty()方法的对象会被遍历
		 * 
		 */		
		public function calculateAllOnce(filter:Boolean = false):void
		{
			for (var i:int = 0; i < data.length;i++)
			{
				var v:* = data[i];
				if ((!filter || dirtys[v]) && needCalculate(v))
				{
					delete dirtys[v];
					command(v);
				}
			}
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
	}
}