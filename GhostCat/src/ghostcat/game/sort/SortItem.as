package ghostcat.game.sort
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class SortItem extends EventDispatcher
	{
		public function SortItem(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}