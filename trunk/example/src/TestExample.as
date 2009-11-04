package
{
	import flash.events.Event;
	
	import ghostcat.community.tween.TweenGroupByValueManager;
	import ghostcat.display.GBase;
	import ghostcat.display.loader.AVM1Loader;

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
		public var v:AVM1Loader;
		public function TestExample()
		{
			v = new AVM1Loader();
			addChild(v);
			v.load("test.swf");
			
			v.addEventListener(Event.COMPLETE,completeHandler);
		}
		
		private function completeHandler(event:Event):void
		{
			v.call("gotoAndStop",[2]);
			v.setValue("test",123);
			v.getValue("test",rHandler);
		}
		
		private function rHandler(v:Object):void
		{
			trace(v);
		}
		
		
	}
}