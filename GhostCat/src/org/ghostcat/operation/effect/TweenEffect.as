package org.ghostcat.operation.effect
{
	import org.ghostcat.operation.TweenOper;
	
	public class TweenEffect extends TweenOper implements IEffect
	{
		public function TweenEffect(target:*,duration:int,params:Object)
		{
			super(target,duration,params);
		}
	}
}