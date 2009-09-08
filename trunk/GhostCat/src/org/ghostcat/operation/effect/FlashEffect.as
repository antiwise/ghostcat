package org.ghostcat.operation.effect
{
	import org.ghostcat.operation.RepeatOper;

	public class FlashEffect extends RepeatOper implements IEffect
	{
		public function FlashEffect(target:*, duration:int, fromAlpha:Number = 1.0, toAlpha:Number = 0.5, loop:int = -1)
		{
			var list:Array = [new TweenEffect(target,duration,{alpha:toAlpha}),
							new TweenEffect(target,duration,{alpha:fromAlpha})];
			super(list, loop);
		}
	}
}