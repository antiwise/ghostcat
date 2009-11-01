package ghostcat.operation.effect
{
	import flash.display.DisplayObject;
	import flash.utils.getTimer;
	
	import ghostcat.operation.TweenOper;

	/**
	 * 震动效果
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ShakeEffect extends TweenOper
	{
		/**
		 * 振动周期
		 */
		public var cycle:int;
		
		/**
		 * 起始振幅
		 */
		public var fromValue:Number;
		
		/**
		 * 目标振幅
		 */
		public var toValue:Number;
		
		/**
		 * 缓动函数
		 */
		public var ease:Function;
		
		/**
		 * 目标
		 */
		public var contentTarget:DisplayObject;
		
		/**
		 * 当前振幅
		 */
		public var currentValue:Number;
		
		private const pi2:Number = Math.PI * 2;
		private var startTime:int;
		private var oldY:Number;
		
		/** @inheritDoc*/
		public override function get target():*
		{
			return contentTarget;
		}
		
		public override function set target(v:*):void
		{
			contentTarget = v;
		}
		
		public function ShakeEffect(target:DisplayObject=null, duration:Number = 1000, cycle:int = 100, fromValue:Number = 5.0, toValue:Number = 0.0,ease:Function = null)
		{
			this.contentTarget = target;
			this.cycle = cycle;
			this.fromValue = fromValue;
			this.toValue = toValue;
			
			super(this, duration, {}, invert);
		}
		
		/** @inheritDoc*/
		public override function execute() : void
		{
			startTime = getTimer();
			oldY = contentTarget.y;
			
			currentValue = fromValue;
			params = {currentValue:toValue,ease:ease,onUpdate:updateHandler};
			
			super.execute();
		}
		
		private function updateHandler():void
		{
			contentTarget.y = oldY + currentValue * Math.sin((getTimer() - startTime) / cycle * pi2);
		}
	}
}