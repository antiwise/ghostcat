package ghostcat.display.viewport
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.events.TickEvent;
	import ghostcat.util.Tick;
	import ghostcat.util.display.Geom;
	
	/**
	 * 场景镜头类，帮助移动整个场景
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ViewportCamera extends EventDispatcher
	{
		/**
		 * 容器
		 */
		public var content:DisplayObject;
		
		/**
		 * 屏幕大小
		 */
		public var screen:Rectangle;
		/**
		 * 容器中显示在屏幕里的区域
		 */
		public var area:Rectangle;
		
		private var _target:*;
		
		/**
		 * 缓动速度
		 */
		public var tweenSpeed:Number = 0.2;

		/**
		 * 锁定的目标，可以是特定子级显示对象或者目标area矩形
		 * 
		 * @return 
		 * 
		 */
		public function get target():*
		{
			return _target;
		}

		public function set target(value:*):void
		{
			if (value)
			{
				if (!_target)
					Tick.instance.addEventListener(TickEvent.TICK,tickHandler);
			}
			else
			{
				if (target)
					Tick.instance.removeEventListener(TickEvent.TICK,tickHandler);
			}
			
			_target = value;
		}

		
		public function ViewportCamera(content:DisplayObject,screen:Rectangle = null)
		{
			this.content = content;
			
			this.screen = screen;
			this.area = screen.clone();
		}
		
		public function get areaX():Number
		{
			return area.x;
		}

		public function set areaX(value:Number):void
		{
			area.x = value;
			applyCamera();
		}

		public function get areaY():Number
		{
			return area.y;
		}

		public function set areaY(value:Number):void
		{
			area.y = value;
			applyCamera();
		}
		
		/**
		 * 应用镜头 
		 * 
		 */
		public function applyCamera():void
		{
			if (!area)
				return;
			
			content.scaleX = screen.width / area.width;
			content.scaleY = screen.height / area.height;
			content.x = screen.x - area.x * content.scaleX;
			content.y = screen.y - area.y * content.scaleY;
		}
		
		/**
		 * 时基事件 
		 * @param event
		 * 
		 */
		protected function tickHandler(event:TickEvent):void
		{
			if (target is DisplayObject)
			{
				var t:Point = Geom.center(target).subtract(new Point(area.width / 2,area.height / 2));;
				area.x += (t.x - area.x) * tweenSpeed;
				area.y += (t.y - area.y) * tweenSpeed;
			}
			else if (target is Rectangle)
			{
				area.x += (target.x - area.x) * tweenSpeed;
				area.y += (target.y - area.y) * tweenSpeed;
				area.width += (target.width - area.width) * tweenSpeed;
				area.height += (target.height - area.height) * tweenSpeed;
			}
			applyCamera();
		}
		
		/**
		 * 销毁 
		 * 
		 */
		public function destory():void
		{
			target = null;
		}

	}
}