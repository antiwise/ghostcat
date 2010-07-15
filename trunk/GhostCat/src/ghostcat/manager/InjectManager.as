package ghostcat.manager
{
	import ghostcat.util.core.Singleton;
	
	public class InjectManager extends Singleton
	{
		static public function get instance():InjectManager
		{
			return Singleton.getInstanceOrCreate(InjectManager) as InjectManager;
		}
		
		public function InjectManager()
		{
			super();
		}
	}
}