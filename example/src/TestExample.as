package
{
	import ghostcat.community.tween.TweenGroupByValueManager;
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
			RootManager.register(this);
			
			DisplayUtil.addAllChildren(this,BitmapSeparateUtil.separateBitmapData(new DrawParse(new TestCollision()).createBitmapData(),10,10,true));
			
			g = new TweenGroupByValueManager(1000,{y:"100",autoAlpha:0.0,ease:Circ.easeOut,invert:true});
			g.addAll(this);
			g.start();
			TweenUtil.to(g,10000,{percent:1.0})
		}
		
		
	}
}