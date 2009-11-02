package
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import ghostcat.community.tween.TweenGroupManager;
	import ghostcat.display.GBase;
	import ghostcat.filter.ConvolutionFilterProxy;
	import ghostcat.filter.DisplacementMapFilterProxy;
	import ghostcat.manager.RootManager;
	import ghostcat.operation.effect.ShakeEffect;
	import ghostcat.parse.display.DrawParse;
	import ghostcat.util.display.BitmapSeparateUtil;
	import ghostcat.util.display.DisplayUtil;
	import ghostcat.util.display.SeparateUtil;
	import ghostcat.util.easing.Circ;

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
		
		public function TestExample()
		{
			RootManager.register(this);
			
			DisplayUtil.addAllChildren(this,BitmapSeparateUtil.separateBitmapData(new DrawParse(new TestCollision()).createBitmapData(),10,10,true));
			
			var g:TweenGroupManager = new TweenGroupManager(1000,{y:"100",autoAlpha:0.0,ease:Circ.easeOut,invert:true},20);
			g.addAll(this);
			g.calculateAll();
		}
		
		
	}
}