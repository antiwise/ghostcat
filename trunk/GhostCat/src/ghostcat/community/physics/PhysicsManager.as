package ghostcat.community.physics
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import ghostcat.events.TickEvent;
	import ghostcat.util.Tick;
	
	/**
	 * 物理管理类
	 * @author flashyiyi
	 * 
	 */
	public class PhysicsManager extends EventDispatcher
	{
		/**
		 * 全局加速度（像素/秒*秒）
		 */
		public var gravity:Point;
		
		/**
		 * 更新属性回调方法，参数为PhysicsItem对象和更新间隔毫秒数
		 */

		public var onTick:Function;
		
		private var _paused:Boolean = false;
		
		/**
		 * 是否暂停
		 * @return 
		 * 
		 */
		public function get paused():Boolean
		{
			return _paused;
		}

		public function set paused(v:Boolean):void
		{
			if (_paused == v)
				return;
				
			_paused = v;
			
			if (!v)
				Tick.instance.addEventListener(TickEvent.TICK,tickHandler,false,1000);
			else
				Tick.instance.removeEventListener(TickEvent.TICK,tickHandler);
			
		}
		
		private var dict:Dictionary;
		public function PhysicsManager()
		{
			this.dict = new Dictionary();
			
			Tick.instance.addEventListener(TickEvent.TICK,tickHandler,false,1000);
		}
		
		/**
		 * 添加对象
		 * @param obj
		 * 
		 */
		public function add(obj:*) : void
		{
			var item:PhysicsItem = new PhysicsItem(obj);
			
			dict[obj] = item;
		}
		
		/**
		 * 删除对象
		 * @param obj
		 * 
		 */
		public function remove(obj:*) : void
		{
			delete dict[obj];
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
		
		/**
		 * 设置加速度（像素/秒*秒）
		 * @param obj
		 * @param v
		 * 
		 */
		public function setAcceleration(obj:DisplayObject,v:Point):void
		{
			(dict[obj] as PhysicsItem).acceleration = v;
		}
		
		/**
		 * 设置速度（像素/秒）
		 * @param obj
		 * @param v
		 * 
		 */
		public function setVelocity(obj:DisplayObject,v:Point):void
		{
			(dict[obj] as PhysicsItem).velocity = v;
		}
		
		private function tickHandler(event:TickEvent):void
		{
			tick(event.interval);
		}
		
		public function tick(interval:int):void
		{
			for each (var item:PhysicsItem in dict)
			{
				if (item.acceleration)
				{
					item.velocity.x += item.acceleration.x * interval / 1000;
					item.velocity.y += item.acceleration.y * interval / 1000;
				}
				if (gravity)
				{
					item.velocity.x += gravity.x * interval / 1000;
					item.velocity.y += gravity.y * interval / 1000;
				}
				if (item.friction != 1)
				{
					item.velocity.x *= item.friction;
					item.velocity.y *= item.friction;
				}
				item.x += item.velocity.x * interval / 1000;
				item.y += item.velocity.y * interval / 1000;
				
				if (onTick!=null)
					onTick(item,Infinity);
			}
		}
		
		/**
		 * 销毁方法
		 * 
		 */
		public function destory():void
		{
			paused = true;
		}
	}
}