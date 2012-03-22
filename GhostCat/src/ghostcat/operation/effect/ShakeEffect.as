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
		 * 要改变的属性
		 */
		public var field:String;
		
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
		public var contentTarget:*;
		
		/**
		 * 当前振幅
		 */
		public var currentValue:Number;
		
		private const pi2:Number = Math.PI * 2;
		private var startTime:int;
		private var oldValue:Number;
		
		/** @inheritDoc*/
		public override function get target():*
		{
			return contentTarget;
		}
		
		public override function set target(v:*):void
		{
			contentTarget = v;
		}
		
		public function ShakeEffect(target:*=null, duration:Number = 1000, cycle:int = 100, fromValue:Number = 5.0, toValue:Number = 0.0,ease:Function = null,field:String = "y")
		{
			this.contentTarget = target;
			this.cycle = cycle;
			this.fromValue = fromValue;
			this.toValue = toValue;
			this.field = field;
			
			super(this, duration, {}, invert);
		}
		
		/** @inheritDoc*/
		public override function execute() : void
		{
			startTime = getTimer();
			oldValue = contentTarget[field];
			
			currentValue = fromValue;
			params = {currentValue:toValue,ease:ease,onUpdate:updateHandler};
			
			super.execute();
		}
		
		private function updateHandler():void
		{
			contentTarget[field] = oldValue + currentValue * Math.sin((getTimer() - startTime) / cycle * pi2);
		}
	}
}