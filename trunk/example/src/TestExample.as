package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.ghostcat.display.movieclip.GBitmapMovieClip;
	import org.ghostcat.display.movieclip.MovieClipCacher;
	import org.ghostcat.skin.cursor.CursorArow;
	
	[SWF(width="400",height="400")]
	public class TestExample extends Sprite
	{
		public var c:MovieClipCacher = new MovieClipCacher(new CursorArow());
			
		public function TestExample()
		{
			c.addEventListener(Event.COMPLETE,f);
		}
		
		private function f(event:Event):void
		{
			var p:GBitmapMovieClip = new GBitmapMovieClip(c.result);
			p.x = 50;
			p.y = 50;
			p.frameRate = 10;
			addChild(p);
		}
	}
}