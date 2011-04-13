package ghostcat.ui
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	import ghostcat.events.OperationEvent;
	import ghostcat.operation.Oper;
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
		
		private var _target:IEventDispatcher;
		
		/**
		 * 辅助加载器 
		 */
		public var loadHelper:LoadHelper;
		
		/**
		 * 资源的名字
		 */
		public function get resName():String
		{
			return oper ? oper.name : null;
		}
		
		/**
		 * 资源对应的Oper 
		 */
		public var oper:IProgressTargetClient;
		
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
		public function get target():IEventDispatcher
		{
			return _target;
		}
		
		public function set target(v:IEventDispatcher):void
		{
			if (v is IProgressTargetClient)
			{
				this.oper = v as IProgressTargetClient;
				v = this.oper.eventDispatcher;
			}
			
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
		 * 
		 */
		public function setTarget(v:EventDispatcher):void
		{
			this.target = v;
		}
		
		/**
		 * 设置目标变换 
		 * @param opers
		 * 
		 */
		public function commitTarget(...lists):void
		{
			for (var i:int = 0;i < lists.length;i++)
			{
				if (lists[i] is IEventDispatcher)
				{
					(lists[i] as IEventDispatcher).addEventListener(OperationEvent.OPERATION_START,changeTargetHandler,false,0,true);
					(lists[i] as IEventDispatcher).addEventListener(Event.OPEN,changeTargetHandler,false,0,true);
				}
			}
		}
		
		/**
		 * 设置一组目标变换 
		 * @param opers
		 * 
		 */
		public function commitTargets(list:Array):void
		{
			commitTarget.apply(null,list);
		}
		
		/**
		 * 目标变换函数 
		 * @param event
		 * 
		 */
		protected function changeTargetHandler(event:Event):void
		{
			var currentTarget:IEventDispatcher = event.currentTarget as IEventDispatcher;
			currentTarget.removeEventListener(OperationEvent.OPERATION_START,changeTargetHandler);
			currentTarget.removeEventListener(Event.OPEN,changeTargetHandler);
			
			this.target = currentTarget;
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