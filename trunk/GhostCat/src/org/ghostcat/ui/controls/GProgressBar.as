package org.ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	import org.ghostcat.util.ClassFactory;
	import org.ghostcat.skin.ProgressSkin;
	import org.ghostcat.util.LoadHelper;
	
	/**
	 * 加载进度条
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
		
		public function GProgressBar(skin:DisplayObject=null, replace:Boolean=true, mode:int=0, fields:Object=null)
		{
			if (!skin)
				skin = defaultSkin.newInstance();
			
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
		
		protected function progressHandler(event:ProgressEvent):void
		{
			percent = loadHelper.loadPercent;
			label = loadHelper.loadPercent * 100 + "%" + 
					"(" + loadHelper.bytesLoaded + "/" + loadHelper.bytesTotal + ")";
			if (showNeedTime)
				label += "\n已用时：" + loadHelper.progressTimeString +
						 "\n预计剩余时间：" + loadHelper.progressNeedTimeString;
		}
		
		protected function completeHandler(event:Event):void
		{
			percent = 1.0;
			label = "加载完成";
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			percent = 0.0;
			label = "加载失败";
		}
	}
}