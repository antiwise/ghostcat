package ghostcat.game.layer.collision
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class CollisionManager extends EventDispatcher implements ICollisionManager
	{
		public function CollisionManager(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}