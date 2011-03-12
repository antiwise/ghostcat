package ghostcat.game.collision
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class CollideManager extends EventDispatcher
	{
		public function CollideManager(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}