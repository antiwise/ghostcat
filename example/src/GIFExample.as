package 
{
	import flash.display.Sprite;
	
	import ghostcat.display.movieclip.GBitmapMovieClip;
	import ghostcat.events.OperationEvent;
	import ghostcat.operation.LoadGIFOper;
	
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