package ghostcat.operation.effect
{
	import flash.display.DisplayObject;
	
	import ghostcat.operation.RepeatOper;

	public class FlashEffect extends RepeatEffect
	{
		public var duration:int;
		public var fromAlpha:Number;
		public var toAlpha:Number;
		
		public function FlashEffect(target:*, duration:int, fromAlpha:Number = 1.0, toAlpha:Number = 0.5, loop:int = -1)
		{
			this.duration = duration;
			this.fromAlpha = fromAlpha;
			this.toAlpha = toAlpha;
			
			super(null, loop);
		}
		public override function execute():void
		{
			(target as DisplayObject).alpha = fromAlpha;
			
			var list:Array = [new TweenEffect(target,duration,{alpha:toAlpha}),
							new TweenEffect(target,duration,{alpha:fromAlpha})];
			
			super.execute();
		}
	}
}