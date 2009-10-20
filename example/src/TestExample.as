package
{
	import flash.display.DisplayObject;
	
	import ghostcat.display.GBase;
	import ghostcat.display.movieclip.GBitmapMovieClip;
	import ghostcat.display.viewport.Divide45Util;
	import ghostcat.skin.AlertSkin;
	
	[SWF(width="600",height="600")]
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TestExample extends GBase
	{
		public function TestExample()
		{
			var v:GBitmapMovieClip = new GBitmapMovieClip();
			v.createFromMovieClip(new AlertSkin());
			addChild(v);
			
		}
	}
}