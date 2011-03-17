package ghostcat.game.util
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import ghostcat.events.TickEvent;
	import ghostcat.game.layer.GameLayerBase;
	import ghostcat.operation.Oper;
	import ghostcat.operation.TweenOper;
	import ghostcat.util.Tick;
	import ghostcat.util.easing.Circ;
	import ghostcat.util.easing.Linear;
	import ghostcat.util.easing.TweenEvent;
	
	[Event(name="tween_update",type="ghostcat.util.easing.TweenEvent")]
	
	/**
	 * 沿着固定路径点移动
	 * @author flashyiyi
	 * 
	 */
	public class GameMoveByPathOper extends Oper
	{
		public var path:Array;
		public var layer:GameLayerBase;
		public var speed:Number;
		public var item:DisplayObject;
		public var ease:Function;
		
		private var startTime:int;
		private var stepLength:Array;
		private var totalLength:Number;
		private var len:int;
		
		public var oldPosition:Point;
		public var position:Point;
		
		public function GameMoveByPathOper(path:Array,speed:Number,item:DisplayObject,layer:GameLayerBase = null,ease:Function = null)
		{
			super();
			
			this.path = path;
			this.speed = speed;
			this.layer = layer;
			this.item = item;
			this.ease = ease;
		}
		
		protected function tickHandler(event:TickEvent):void
		{
			oldPosition = position.clone();
			var t:int = getTimer() - startTime;
			var p:Number;
			if (ease != null)
				p = ease(t,0,totalLength,len);
			else
				p = t * speed;
			
			position = getPosition(p);
			
			if (layer)
			{
				this.layer.setObjectPosition(item,position);
			}
			else
			{
				item.x = position.x;
				item.y = position.y;
			}
			this.dispatchEvent(new TweenEvent(TweenEvent.TWEEN_UPDATE));
			
			if (t >= len)
				result();
		}
		
		public function getPosition(pos:Number):Point
		{
			var step:int = 0;
			var l:int = stepLength.length;
			while (step < l && pos > stepLength[step])
				step++;
			
			if (step < l)
			{
				var prevLength:Number = step > 0 ? stepLength[step - 1] : 0;
				var curLength:Number = stepLength[step] - prevLength;
				return Point.interpolate(path[step + 1],path[step],(pos - prevLength) / curLength);
			}
			else
			{
				return path[path.length - 1];
			}
		}
		
		override public function execute():void
		{
			Tick.instance.addEventListener(TickEvent.TICK,tickHandler,false,0,false);
			startTime = getTimer();
						
			this.stepLength = [];
			for (var i:int = 0;i < path.length - 1;i++)
			{
				var prevLength:Number = i > 0 ? this.stepLength[i - 1] : 0;
				this.stepLength[i] = prevLength + Point.distance(path[i],path[i + 1]);
			}
			this.totalLength = this.stepLength[this.stepLength.length - 1];
			this.len = this.totalLength / speed;
			this.position = this.oldPosition = path[0];
			
			tickHandler(null);
			
			super.execute();
		}
		
		override protected function end(event:*=null):void
		{
			Tick.instance.removeEventListener(TickEvent.TICK,tickHandler);
			super.end(event);
		}		
	}
}