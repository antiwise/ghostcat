package ghostcat.operation.effect
{
	import ghostcat.operation.Queue;
	
	/**
	 * 队列效果 
	 * @author Administrator
	 * 
	 */
	public class QueueEffect extends Queue implements IEffect
	{
		/** @inheritDoc*/
		public function get target():*
		{
			return null;
		}
		
		public function set target(v:*):void
		{
		}
		
		public function QueueEffect(data:Array=null)
		{
			super(data);
		}
	}
}