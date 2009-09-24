package
{
	import flash.display.Sprite;
	
	import ghostcat.manager.RootManager;
	import ghostcat.ui.containers.GAlert;
	
	[SWF(width="600",height="600")]
	public class TestExample extends Sprite
	{
		public function TestExample()
		{	
			RootManager.register(this);
			
			GAlert.show("123");
		}
	}
}