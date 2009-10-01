package ghostcat.ui.controls
{
	import flash.display.DisplayObject;
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
		public static var defaultSkin:ClassFactory = new ClassFactory(ProgressSkin);
		/**
		 * 是否显示剩余时间
		 */
		public var showNeedTime:Boolean = true;
		
		public function GProgressBar(skin:*=null, replace:Boolean=true, mode:int=1, fields:Object=null)
		{
			if (!skin)
				skin = defaultSkin;
			
			super(skin, replace, mode, fields);
		}
		
		private var _target:EventDispatcher;
		private var loadHelper:LoadHelper;
		
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
		 * 进度事件 
		 * @param event
		 * 
		 */
		protected function progressHandler(event:ProgressEvent):void
		{
			percent = loadHelper.loadPercent;
			label = (loadHelper.loadPercent * 100).toFixed(1) + "%" + 
					"(" + loadHelper.bytesLoaded + "/" + loadHelper.bytesTotal + ")";
			if (showNeedTime)
				label += "\n已用时：" + loadHelper.progressTimeString +
						 "\n预计剩余时间：" + loadHelper.progressNeedTimeString;
		}
		
		/**
		 * 完成事件 
		 * @param event
		 * 
		 */
		protected function completeHandler(event:Event):void
		{
			percent = 1.0;
			label = "加载完成";
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * 错误事件 
		 * @param event
		 * 
		 */
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			percent = 0.0;
			label = "加载失败";
			
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR))
		}
	}
}