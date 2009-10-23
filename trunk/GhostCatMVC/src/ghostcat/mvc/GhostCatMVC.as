package ghostcat.mvc
{
	import ghostcat.util.core.Singleton;
	
	public class GhostCatMVC extends Singleton
	{
		static public function get instance():GhostCatMVC
		{
			return Singleton.getInstanceOrCreate(GhostCatMVC) as GhostCatMVC;
		}
		
		public function GhostCatMVC()
		{
			super();
		}
		
		public function load(...params):void
		{
			
		}
		
		public function unLoad(...params):void
		{
			
		}
	}
}