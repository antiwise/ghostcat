package ghostcat.operation.effect
{
	import ghostcat.operation.GroupOper;
	
	/**
	 * 组效果 
	 * @author Administrator
	 * 
	 */
	public class GroupEffect extends GroupOper implements IEffect
	{
		/** @inheritDoc*/
		public function get target():*
		{
			if (children && children.length > 0 && children[0] is IEffect)
				return (children[0] as IEffect).target;
			else
				return null;
		}
		
		public function set target(v:*):void
		{
			for each (var oper:* in children)
			{
				if (oper is IEffect)
					(oper as IEffect).target = v;
			}
		}
		
		public function GroupEffect(children:Array=null)
		{
			super(children);
		}
	}
}