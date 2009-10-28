package
{
	import flash.geom.Rectangle;
	
	import ghostcat.display.GBase;
	import ghostcat.display.movieclip.GScriptMovieClip;
	import ghostcat.display.transition.maskmovie.ShutterMaskHandler;

	[SWF(width="600",height="450",backgroundColor="0xFFFFFF")]
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TestExample extends GBase
	{
		public function TestExample()
		{
			
			var v:GScriptMovieClip = new GScriptMovieClip(new ShutterMaskHandler(),25,null,new Rectangle(0,0,600,450))
			v.setLoop(1);
			addChild(v);
		}
	}
}