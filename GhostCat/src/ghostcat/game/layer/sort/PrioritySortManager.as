package ghostcat.game.layer.sort
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import ghostcat.util.display.BitmapUtil;
	
	public class PrioritySortManager extends EventDispatcher
	{
		public function PrioritySortManager(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}