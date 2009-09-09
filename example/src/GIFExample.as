package 
{
	import flash.display.Sprite;
	
	import org.ghostcat.display.movieclip.GBitmapMovieClip;
	import org.ghostcat.events.OperationEvent;
	import org.ghostcat.operation.LoadGIFOper;
	
	[SWF(width="500",height="400")]
	public class GIFExample extends Sprite
	{
		public var loader:LoadGIFOper;
		public function GIFExample()
		{
			loader = new LoadGIFOper("dance.gif",null,rhandler);
			loader.commit();
		}
		
		private function rhandler(event:OperationEvent):void
		{
			var movie:GBitmapMovieClip = new GBitmapMovieClip(loader.data as Array);
			movie.frameRate = 10;
			addChild(movie);
		}
	}
}