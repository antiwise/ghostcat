package
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import ghostcat.community.tween.TweenGroupByValueManager;
	import ghostcat.debug.Debug;
	import ghostcat.display.GBase;
	import ghostcat.display.loader.AVM1Loader;
	import ghostcat.manager.RootManager;
	import ghostcat.parse.display.DrawParse;
	import ghostcat.util.display.BitmapSeparateUtil;
	import ghostcat.util.display.DisplayUtil;
	import ghostcat.util.easing.Circ;
	import ghostcat.util.easing.TweenUtil;

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
			v.call("gotoAndStop",2);
			v.setValue("test",123);
			v.getValue("test");
		}
		
		
	}
}