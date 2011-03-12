package ghostcat.game.item
{
	import ghostcat.display.movieclip.GBitmapMovieClip;
	
	public class BitmapMovieGameItem extends GBitmapMovieClip implements IGameItem
	{
		public function BitmapMovieGameItem(bitmaps:Array=null, labels:Array=null, paused:Boolean=false)
		{
			super(bitmaps, labels, paused);
			this.enabledDelayUpdate = false;
		}
	}
}