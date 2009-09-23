package ghostcat.operation.effect
{
	import ghostcat.operation.Queue;
	
	public class QueueEffect extends Queue implements IEffect
	{
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