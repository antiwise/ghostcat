package ghostcat.operation.effect
{
	import ghostcat.operation.TweenOper;
	
	public class TweenEffect extends TweenOper
	{
		public function TweenEffect(target:*,duration:int,params:Object,invert:Boolean = false)
		{
			super(target,duration,params,invert);
		}
		
		public override function execute() : void
		{
			super.execute();
			
			if (invert)
				tween.update();//执行update确认属性
		}
	}
}