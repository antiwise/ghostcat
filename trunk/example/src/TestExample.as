package
{
	import flash.geom.Rectangle;
	
	import ghostcat.community.tween.TweenGroupByValueManager;
	import ghostcat.debug.Debug;
	import ghostcat.display.GBase;
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
		public function TestExample()
		{
			Debug.traceObject(null,new Rectangle(1,1,5,5),"left","right","top","bottom");
			Debug.traceObject(null,{a:1,b:1});
		}
		
		
	}
}