package ghostcat.ui
{
	import flash.events.Event;
	
	import ghostcat.ui.controls.GProgressBar;
	import ghostcat.util.easing.Elastic;
	import ghostcat.util.load.RootLoaderBase;
	
	/**
	 * 自加载方式的实现。由于使用了组件的进度条，加载条本身就有14K的体积。
	 * 如果对此不满的话，可以自己按需求再写一个。
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class RootLoader extends RootLoaderBase
	{
		/**
		 * 进度条 
		 */
		public var progressSprite:GProgressBar;
		public function RootLoader()
		{
			super();
			progressSprite = new GProgressBar();
			progressSprite.target = this;
			progressSprite.duration = 1000;
			progressSprite.ease = Elastic.easeOut;
			addChild(progressSprite);
			
			stage.addEventListener(Event.RESIZE,resizeHandler);
			resizeHandler();
		}
		
		private function resizeHandler(event:Event = null):void
		{
			progressSprite.x = (stage.stageWidth - progressSprite.width)/2;
			progressSprite.y = (stage.stageHeight - 50)/2;
		}
		/** @inheritDoc*/
		protected override function loadComplete():void 
		{
			removeChild(progressSprite);
			stage.removeEventListener(Event.RESIZE,resizeHandler);
			
			super.loadComplete();
		}
	}
}