package ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	
	import ghostcat.util.LoadHelper;
	
	[Event(name="complete",type="flash.events.Event")]
	[Event(name="io_error",type="flash.events.IOErrorEvent")]
	
	/**
	 * 等待服务器返回时显示的提示，将不显示进度
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GServerWaitBar extends GPercentBar
	{
		protected var loadHelper:LoadHelper;
		
		public function GServerWaitBar(skin:DisplayObject=null, replace:Boolean=true, mode:int=0, fields:Object=null)
		{
			super(skin, replace, mode, fields);
		}
		
		protected var _target:EventDispatcher;
		
		/**
		 * 设置进度条目标。请在加载器的load方法执行前设置。
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
				loadHelper.removeEventListener(Event.COMPLETE,completeHandler);
				loadHelper.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
				loadHelper.destory();
			}
			_target = v;
			
			loadHelper = new LoadHelper(_target);
			loadHelper.addEventListener(Event.COMPLETE,completeHandler);
			loadHelper.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
		}
		
		protected function completeHandler(event:Event):void
		{
			label = "加载完成";
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			label = "加载失败";
			
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR))
		}
	}
}