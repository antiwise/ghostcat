package
{
	import flash.display.DisplayObject;
	
	import ghostcat.display.GBase;
	import ghostcat.manager.RootManager;
	import ghostcat.operation.effect.ShakeEffect;

	[SWF(width="600",height="450")]
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TestExample extends GBase
	{
		public function TestExample()
		{
			RootManager.register(this);
			var v:DisplayObject = new TestCollision();
			addChild(v);
			
			new ShakeEffect(v).execute();
		}
	}
}