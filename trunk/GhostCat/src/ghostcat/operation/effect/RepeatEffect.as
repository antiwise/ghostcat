package ghostcat.operation.effect
{
	import ghostcat.operation.RepeatOper;
	
	public class RepeatEffect extends RepeatOper implements IEffect
	{
		private var _target:*;
		public function get target():*
		{
			return _target;
		}
		
		public function set target(v:*):void
		{
			_target = v;
		}
		
		public function RepeatEffect(list:Array, loop:int)
		{
			super(list, loop);
		}
	}
}