package
{
	import flash.display.Sprite;
	
	import ghostcat.debug.Debug;
	import ghostcat.debug.DebugPanel;
	import ghostcat.manager.RootManager;
	import ghostcat.util.easing.Elastic;Elastic;
	
	import ghostcat.util.ReflectUtil;
	import ghostcat.ui.containers.GAlert;
	
	[SWF(width="600",height="600")]
	public class TestExample extends Sprite
	{
		public function TestExample()
		{	
			RootManager.register(this);
			
			new DebugPanel(stage);
			
			Debug.trace(null,"123123")
			Debug.trace(null,"123123")
			Debug.trace(null,"123123")
			Debug.trace(null,"123123")
			
			GAlert.show("测试文本测试文本测试文本测试文本\n测试文本测试文本测试文本","标题",["1","2"]);
		}
	}
}