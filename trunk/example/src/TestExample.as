package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import ghostcat.operation.effect.AlphaClipEffect;
	
	[SWF(width="600",height="600")]
	public class TestExample extends Sprite
	{
		public function TestExample()
		{	
			var v:DisplayObject = new TestHuman();
			addChild(v);
			
			v.x = 100;
			v.y = 100;
			
			new AlphaClipEffect(v,5000,AlphaClipEffect.DOWN,null).execute();
		}
	}
}