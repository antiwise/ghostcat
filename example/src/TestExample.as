package
{
	import flash.display.Sprite;
	
	import ghostcat.ui.LayoutUtil;
	
	[SWF(width="600",height="600")]
	public class TestExample extends Sprite
	{
		public function TestExample()
		{	
			var t:Sprite = new TestCollision();
			addChild(t);
			
			LayoutUtil.percent(t,stage,1,1);
			LayoutUtil.center(t,stage,0,0);
//			LayoutUtil.metrics(t,stage,NaN,NaN,0,0);
			
		}
	}
}