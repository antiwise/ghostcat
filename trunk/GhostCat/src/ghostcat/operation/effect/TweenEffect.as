package ghostcat.operation.effect
{
	import ghostcat.operation.TweenOper;
	
	/**
	 * 缓动效果
	 * @author flashyiyi
	 * 
	 */
	public class TweenEffect extends TweenOper
	{
		public function TweenEffect(target:*=null,duration:int=1000,params:Object=null,invert:Boolean = false)
		{
			super(target,duration,params,invert);
		}
		/** @inheritDoc*/
		public override function execute() : void
		{
			super.execute();
			
			if (invert)
				tween.update();//执行update确认属性
		}
	}
}