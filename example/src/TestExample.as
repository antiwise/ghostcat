package
{
	import flash.display.Sprite;
	
	import ghostcat.debug.Debug;
	import ghostcat.debug.DebugPanel;
	import ghostcat.manager.RootManager;
	import ghostcat.util.easing.Elastic;Elastic;
	
	import ghostcat.util.ReflectUtil;
	import ghostcat.ui.containers.GAlert;
	import ghostcat.ui.CursorSprite;
	import ghostcat.parse.display.TextFieldParse;
	import ghostcat.util.RandomUtil;
	
	[SWF(width="600",height="600")]
	
	/**
	 * 可按下Cirl+D呼出显示trace信息的窗口
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TestExample extends Sprite
	{
		public function TestExample()
		{	
			RootManager.register(this);
			
			new DebugPanel(stage);
			addChild(new CursorSprite());
			
			new TextFieldParse("按下Cirl+D呼出显示trace信息的窗口").parse(this);
			
			for (var i:int = 0;i< 100;i++)
				Debug.trace(null,RandomUtil.string(10));
		}
	}
}