package 
{
	import ghostcat.display.GSprite;
	import ghostcat.display.movieclip.GBitmapMovieClip;
	import ghostcat.manager.RootManager;
	import ghostcat.operation.FunctionOper;
	import ghostcat.operation.LoadGIFOper;
	import ghostcat.ui.containers.GAlert;
	import ghostcat.ui.controls.GProgressBar;
	
	[SWF(width="500",height="400")]
	/**
	 * GIF载入播放例子
	 * 
	 * GIF解析速度很慢，实际上并不具有太多的实用性。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GIFExample extends GSprite
	{
		public var loader:LoadGIFOper;
		public var pBar:GProgressBar;
		protected override function init():void
		{
			RootManager.register(this);
		
			GAlert.show("点击开始下载图片");
			new FunctionOper(load).commit();
		}
		private function load():void
		{
			pBar = new GProgressBar();
			addChild(pBar);
			
			loader = new LoadGIFOper("dance.gif");
			pBar.target = loader;
			loader.commit();
			new FunctionOper(show).commit();
		}
		
		private function show():void
		{
			var movie:GBitmapMovieClip = new GBitmapMovieClip(loader.data as Array);
			movie.frameRate = 10;
			addChild(movie);
		}
	}
}