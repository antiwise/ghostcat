package
{
	import flash.display.Bitmap;
	
	import ghostcat.debug.FPS;
	import ghostcat.debug.FrameRatePanel;
	import ghostcat.display.GBase;
	import ghostcat.display.movieclip.GMovieClip;
	import ghostcat.events.TickEvent;
	import ghostcat.manager.RootManager;
	import ghostcat.operation.RepeatOper;
	import ghostcat.operation.TweenOper;
	import ghostcat.skin.AlertSkin;
	import ghostcat.util.easing.Circ;

	[SWF(width="600",height="450")]
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TestExample extends GBase
	{
		public var maskBitmap:Bitmap = new Bitmap();
		
		public function TestExample()
		{
			RootManager.register(this);
			
			FrameRatePanel.show(stage);
			
			var v:GMovieClip = new GMovieClip(new AlertSkin());
			v.x = 150;
			v.y = 100;
			addChild(v)
			
			addChild(new FPS());
			
			new RepeatOper([new TweenOper(v,3000,{x:"300",ease:Circ.easeInOut}),new TweenOper(v,3000,{x:"-300",ease:Circ.easeInOut})]).commit();
		}
		
		protected override function tickHandler(event:TickEvent) : void
		{
		}
	}
}