package ghostcat.operation.effect
{
	import flash.display.DisplayObject;
	
	import ghostcat.operation.RepeatOper;

	/**
	 * 透明度闪烁效果
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class FlashEffect extends RepeatEffect
	{
		/**
		 * 持续时间
		 */
		public var duration:int;
		/**
		 * 其实透明度
		 */
		public var fromAlpha:Number;
		/**
		 * 结束透明度 
		 */
		public var toAlpha:Number;
		
		public function FlashEffect(target:*=null, duration:int=1000, fromAlpha:Number = 1.0, toAlpha:Number = 0.5, loop:int = -1)
		{
			super(null, loop);
			
			this.target = target;
			this.duration = duration;
			this.fromAlpha = fromAlpha;
			this.toAlpha = toAlpha;
		}
		/** @inheritDoc*/
		public override function execute():void
		{
			(target as DisplayObject).alpha = fromAlpha;
			
			this.list = [new TweenEffect(target,duration,{alpha:toAlpha}),
							new TweenEffect(target,duration,{alpha:fromAlpha})];
			
			super.execute();
		}
	}
}