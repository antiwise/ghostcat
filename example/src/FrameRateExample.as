package
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import ghostcat.debug.FPS;
	import ghostcat.debug.FrameRateControl;
	import ghostcat.display.GBase;
	import ghostcat.display.movieclip.GMovieClip;
	import ghostcat.manager.InputManager;
	import ghostcat.manager.RootManager;
	import ghostcat.operation.RepeatOper;
	import ghostcat.operation.TweenOper;
	import ghostcat.parse.display.TextFieldParse;
	import ghostcat.util.easing.Circ;

	[SWF(width="600",height="450")]
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class FrameRateExample extends GBase
	{
		public var maskBitmap:Bitmap = new Bitmap();
		
		public function FrameRateExample()
		{
			RootManager.register(this);
			
			InputManager.register(this,false);
			InputManager.instance.inactiveTime = 1000;
			
			FrameRateControl.register(stage);
			FrameRateControl.showPanel();
			
			var v:GMovieClip = new GMovieClip(mc);
			v.x = 150;
			v.y = 100;
			addChild(v)
			
			addChild(new FPS());
			
			new TextFieldParse("GhostCat的动画和缓动效果都是和帧数无关的，因此可以通过上面的面板来调整播放器的帧数以控制性能。\n在相当大的一个范围内动画的播放速度都是相同的。\n\n为了方便演示，暂离降帧时间设成了1秒（默认是60秒），这样可以解决挂机时游戏占用系统资源的问题。",new Point(20,320)).parse(this);
			
			new RepeatOper([new TweenOper(v,3000,{x:"300",ease:Circ.easeInOut}),new TweenOper(v,3000,{x:"-300",ease:Circ.easeInOut})]).commit();
		}
	}
}