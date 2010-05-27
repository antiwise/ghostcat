package ghostcat.ui.controls
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	import ghostcat.skin.ProgressSkin;
	import ghostcat.util.core.ClassFactory;
	import ghostcat.util.load.LoadHelper;
	
	[Event(name="complete",type="flash.events.Event")]
	[Event(name="io_error",type="flash.events.IOErrorEvent")]
	
	/**
	 * 加载进度条
	 * 
	 * 标签规则：和PercentBar相同
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GProgressBar extends GPercentBar
	{
		public static var defaultSkin:* = ProgressSkin;
		
		public function GProgressBar(skin:*=null, replace:Boolean=true, mode:String="scaleX", fields:Object=null)
		{
			if (!skin)
				skin = defaultSkin;
			
			this.progressFunction = defaultProgressFunction;
			
			super(skin, replace, mode, fields);
		}
		
		private var _target:EventDispatcher;
		
		/**
		 * 辅助加载器 
		 */
		public var loadHelper:LoadHelper;
		
		/**
		 * 资源的名字
		 */
		public var resName:String;
		
		/**
		 * 进度条更新方法（参数为进度条）
		 */
		public var progressFunction:Function;
		
		/**
		 * 设置进度条目标。请在load方法执行前设置。
		 * 
		 * @return 
		 * 
		 */
		public function get target():EventDispatcher
		{
			return _target;
		}
		
		public function set target(v:EventDispatcher):void
		{
			if (_target == v)
				return;
			
			if (loadHelper)
			{
				loadHelper.removeEventListener(ProgressEvent.PROGRESS,progressHandler);
				loadHelper.removeEventListener(Event.COMPLETE,completeHandler);
				loadHelper.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
				loadHelper.destory();
			}
			
			_target = v;
			
			percent = 0;
			
			loadHelper = new LoadHelper(_target);
			loadHelper.addEventListener(ProgressEvent.PROGRESS,progressHandler);
			loadHelper.addEventListener(Event.COMPLETE,completeHandler);
			loadHelper.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
		}
		
		/**
		 * 设置目标
		 * 
		 * @param v	资源加载器的loadInfo
		 * @param resName	资源名称
		 * 
		 */
		public function setTarget(v:EventDispatcher,resName:String = null):void
		{
			this.target = v;
			this.resName = resName;
		}
		
		/**
		 * 进度事件 
		 * @param event
		 * 
		 */
		protected function progressHandler(event:ProgressEvent):void
		{
			this.progressFunction(this);
		}
		
		/**
		 * 默认进度事件 
		 * @param progress
		 * 
		 */
		public static function defaultProgressFunction(progress:GProgressBar):void
		{
			progress.percent = progress.loadHelper.loadPercent;
			progress.label = (progress.resName ? progress.resName + "\n" : "") +
				(progress.loadHelper.loadPercent * 100).toFixed(1) + "%" + 
				"(" + progress.loadHelper.bytesLoaded + "/" + progress.loadHelper.bytesTotal + ")" + 
				"\n已用时：" + progress.loadHelper.progressTimeString +
				"\n预计剩余时间：" + progress.loadHelper.progressNeedTimeString;
		}
		
		/**
		 * 完成事件 
		 * @param event
		 * 
		 */
		protected function completeHandler(event:Event):void
		{
			percent = 1.0;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * 错误事件 
		 * @param event
		 * 
		 */
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR))
		}
	}
}