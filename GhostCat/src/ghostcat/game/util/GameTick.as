package ghostcat.game.util
{
	import ghostcat.util.Tick;
	
	public class GameTick extends Tick
	{
		static private var _instance:Tick;
		static public function get instance():Tick
		{
			if (!_instance)
				_instance = new Tick();
			
			return _instance;
		}
	}
}