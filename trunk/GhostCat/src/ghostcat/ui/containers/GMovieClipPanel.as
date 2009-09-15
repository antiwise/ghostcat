package ghostcat.ui.containers
{
	import flash.display.MovieClip;
	
	import ghostcat.display.movieclip.GMovieClip;
	
	public class GMovieClipPanel extends GMovieClip
	{
		public function GMovieClipPanel(mc:MovieClip=null, replace:Boolean=true, paused:Boolean=false)
		{
			super(mc, replace, paused);
		}
	}
}