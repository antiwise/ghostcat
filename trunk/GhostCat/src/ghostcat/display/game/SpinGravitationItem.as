package ghostcat.display.game
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import ghostcat.events.TickEvent;
	import ghostcat.util.Tick;


	/**
	 * 旋转引力生成器
	 * @author flashyiyi
	 * 
	 */
	public class SpinGravitationItem extends EventDispatcher
	{
		public var body:DisplayObject;
		
		protected var target:DisplayObject;
		protected var radius:Number;
		protected var speed:Number;
		
		private var step:int;
		
		private var startRotation:Number;
		private var startTime:int;
		private var spinTime:int;
		
		public function SpinGravitationItem(body:DisplayObject=null)
		{
			this.body = body;
			this.reset();
		}
		
		public function reset():void
		{
			this.step = 0;
			this.target = null;
		}
		
		public function start(target:DisplayObject,radius:Number = 50,speed:Number = 500):void
		{
			this.target = target;
			this.radius = radius;
			this.speed = speed;
			
			this.step = 1;
			
			Tick.instance.addEventListener(TickEvent.TICK,tickHandler);
		}
		
		public function stop():void
		{
			this.step = 0;
			Tick.instance.removeEventListener(TickEvent.TICK,tickHandler);
		}
		
		protected function tickHandler(event:TickEvent):void
		{
			if (step == 0 || step == 3)
				return;
				
			if (step == 1)
			{
				var dp:Point = new Point(target.x - body.x,target.y - body.y);
				var rotate:Number = Math.atan2(dp.y,dp.x) + Math.PI;
				
				if (Math.abs(dp.length - radius) < 10)
				{
					step = 2;
					
					startRotation = rotate;
					startTime = getTimer();
					spinTime = Math.PI * 2 * radius / speed * 1000;	
				}
				else
				{
					if (dp.length > radius)
					{
						dp.x += radius * Math.cos(rotate + Math.PI / 2);
						dp.y += radius * Math.sin(rotate + Math.PI / 2);
					}
					else
					{
						dp.x = -dp.x + radius * Math.cos(rotate + Math.PI / 2);
						dp.y = -dp.y + radius * Math.sin(rotate + Math.PI / 2);
					}
					var dl:Number = event.interval * speed / 1000;
					dp.normalize(dl);
						
					body.x += dp.x;
					body.y += dp.y;
				}
			
			}
			else if (step == 2)
			{
				var t:Number = (getTimer() - startTime) / spinTime;
				var r:Number = startRotation + Math.PI * 2 * t;
				body.x = target.x + radius * (1 - t) * Math.cos(r); 
				body.y = target.y + radius * (1 - t) * Math.sin(r); 
				
				if (t > 1.0)
				{
					dispatchEvent(new Event(Event.COMPLETE));
					stop();
				}
			}
		}
		
	}
}