package
{
	import flash.display.Sprite;
	
	import ghostcat.ui.CursorSprite;
	import ghostcat.ui.containers.GResizePanel;
	
	[SWF(width="600",height="600")]
	public class TestExample extends Sprite
	{
		public function TestExample()
		{	
			var t:GResizePanel = new GResizePanel(new TestCollision());
			addChild(t);
			
			addChild(new CursorSprite())
		}
	}
}