package ghostcat.operation.effect
{
	import ghostcat.operation.RepeatOper;
	
	/**
	 * 重复效果
	 * @author flashyiyi
	 * 
	 */
	public class RepeatEffect extends RepeatOper implements IEffect
	{
		/** @inheritDoc*/
		public function get target():*
		{
			return (children && children.length > 0) ? children[0] : null;
		}
		
		public function set target(v:*):void
		{
			for each (var oper:* in children)
			{
				if (oper is IEffect)
					(oper as IEffect).target = v;
			}
		}
		
		public function RepeatEffect(children:Array=null, loop:int=-1)
		{
			super(children, loop);
		}
	}
}