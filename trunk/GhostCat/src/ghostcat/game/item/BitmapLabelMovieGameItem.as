package ghostcat.game.item
{
	import ghostcat.display.movieclip.GBitmapMovieClip;
	
	public class BitmapLabelMovieGameItem extends GBitmapMovieClip implements IGameItem
	{
		public function BitmapLabelMovieGameItem(bitmaps:Array=null, labels:Array=null, paused:Boolean=false)
		{
			super(bitmaps, labels, paused);
			this.enabledDelayUpdate = false;
		}
	}
}