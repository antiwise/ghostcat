package ghostcat.operation.effect
{
	import ghostcat.operation.Queue;
	
	/**
	 * 队列效果 
	 * @author flashyiyi
	 * 
	 */
	public class QueueEffect extends Queue implements IEffect
	{
		public var data:Array;
		
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
			for each (var oper:* in data)
			{
				if (oper is IEffect)
					(oper as IEffect).target = v;
			}
		}
		
		public function QueueEffect(data:Array=null)
		{
			this.data = data;
			super();
		}
		
		/** @inheritDoc*/
		public override function execute() : void
		{
			this.children = this.data.concat();
			
			super.execute();
		}
	}
}