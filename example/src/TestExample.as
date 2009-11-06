package
{
	import flash.events.Event;
	
	import ghostcat.community.tween.TweenGroupByValueManager;
	import ghostcat.display.GBase;
	import ghostcat.display.loader.AVM1Loader;
	import ghostcat.util.core.Asyn;

	[SWF(width="600",height="450")]
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TestExample extends GBase
	{
		[Embed(source="p1.jpg")]
		public var p1:Class;
		
		public var g:TweenGroupByValueManager;
		public var v:int = 0;
		public function TestExample()
		{
			Asyn.autoSetInv(stage);
			Asyn.asynFor(function ():void {trace(++v)},0,1000000);
		}
		
		
	}
}