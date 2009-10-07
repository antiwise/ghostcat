package 
{
	import flash.events.Event;
	
	import ghostcat.display.GSprite;
	import ghostcat.display.movieclip.GBitmapMovieClip;
	import ghostcat.manager.RootManager;
	import ghostcat.operation.FunctionOper;
	import ghostcat.operation.LoadGIFOper;
	import ghostcat.ui.containers.GAlert;
	import ghostcat.ui.controls.GHSilder;
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
		public var movie:GBitmapMovieClip;
		public var slider:GHSilder;
		protected override function init():void
		{
			RootManager.register(this);
		
			GAlert.show("点击开始下载图片");
			new FunctionOper(load).commit();
		}
		private function load():void
		{
			//加入进度条
			pBar = new GProgressBar();
			addChild(pBar);
			
			//加载GIF
			loader = new LoadGIFOper("dance.gif");
			pBar.target = loader;
			loader.commit();
			new FunctionOper(show).commit();
		}
		
		private function show():void
		{
			var data:Array = loader.data as Array;
			movie = new GBitmapMovieClip(data);
			movie.frameRate = 10;
			addChild(movie);
			
			slider = new GHSilder();
			slider.x = 5;
			slider.y = 170;
			slider.width = 155;
			slider.minValue = -20;
			slider.maxValue = 20;
			slider.value = 10;
			addChild(slider);
			slider.addEventListener(Event.CHANGE,sliderChangeHandler);
		}
		
		private function sliderChangeHandler(event:Event):void
		{
			movie.frameRate = slider.value;
		}
	}
}