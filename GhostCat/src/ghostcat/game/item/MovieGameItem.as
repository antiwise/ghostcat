package ghostcat.game.item
{
	import ghostcat.display.movieclip.GMovieClip;
	
	public class MovieGameItem extends GMovieClip implements IGameItem
	{
		public function MovieGameItem(mc:*=null, paused:Boolean=false)
		{
			super(mc, paused);
			this.enabledDelayUpdate = false;
		}
	}
}