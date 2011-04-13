package ghostcat.display.transition
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import ghostcat.events.OperationEvent;
	import ghostcat.operation.Oper;
	import ghostcat.util.core.AbstractUtil;
	import ghostcat.util.core.Handler;
	
	[Event(name="complete",type="flash.events.Event")]
	
	/**
	 * 过渡动画基类，用于处理场景切换
	 * 
	 * 此类无法实例化
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TransitionLayerBase extends EventDispatcher
	{
		public static const FADE_IN:String = "fade_in";
		public static const FADE_OUT:String = "fade_out";
		public static const WAIT:String = "wait";
		public static const END:String = "end";
		
		public static var currentTransition:TransitionLayerBase;
		
		/**
		 * 让当前动画进入到消去状态。设置wait为无限循环时可执行此方法退出等待状态
		 * 
		 */
		public static function continueFadeOut():void
		{
			currentTransition.state = FADE_OUT;
		}
		
		/**
		 * 进入时的动画名称数组
		 */
		public var fadeIn:Oper;
		
		/**
		 * 等待时的动画名称
		 */
		public var wait:Oper;
		
		/**
		 * 消去时的动画名称数组，完毕后将会删除自身
		 */
		public var fadeOut:Oper;
		
		/**
		 * 切换屏幕时执行的方法
		 */
		public var switchHandler:Handler;
		
		/**
		 * 是否在动画结束后执行result
		 */
		public var resultAtEnd:Boolean = true;
		
		private var _state:String;
		
		/**
		 * 当前状态 
		 * @return 
		 * 
		 */
		public function get state():String
		{
			return _state;
		}
		
		public function set state(v:String):void
		{
			if (_state == v)
				return;
			
			_state = v;
			switch (_state)
			{
				case FADE_IN:
					playAnimate(fadeIn,WAIT);
					break;
				case WAIT:
					if (switchHandler)
						switchHandler.call();
					
					if (!resultAtEnd)
						dispatchEvent(new Event(Event.COMPLETE));
					
					playAnimate(wait,FADE_OUT);
					break;
				case FADE_OUT:
					playAnimate(fadeOut,END);
					break;
				case END:
					destory();
					break;
			}
		}
		
		/**
		 * 跳转动画
		 * @param oper
		 * @param nextState
		 * 
		 */
		protected function playAnimate(oper:Oper,nextState:String):void
		{
			if (oper)
			{
				oper.addEventListener(OperationEvent.OPERATION_COMPLETE,operCompleteHandler);
				oper.execute();
			}
			else
				state = nextState;
			
			function operCompleteHandler(event:Event):void
			{
				removeEventListener(OperationEvent.OPERATION_COMPLETE,operCompleteHandler);
				state = nextState;
			}
		}
		
		public function TransitionLayerBase(switchHandler:*,fadeIn:Oper = null, fadeOut:Oper = null, wait:Oper = null)
		{
			AbstractUtil.preventConstructor(this,TransitionLayerBase);
			
			if (switchHandler is Function)
				this.switchHandler = new Handler(switchHandler);
			else
				this.switchHandler = switchHandler;
			
			this.fadeIn = fadeIn;
			this.fadeOut = fadeOut;
			this.wait = wait;
		}
		
		/**
		 * 创建过渡动画到某个层
		 * 
		 * @param container	动画层所在的容器
		 * @return 
		 * 
		 */
		public function createTo(container:DisplayObjectContainer):TransitionLayerBase
		{
			this.state = FADE_IN;
			
			currentTransition = this;
			return currentTransition;
		}
		
		/**
		 * 让当前动画进入到消去状态。设置wait为无限循环时可执行此方法退出等待状态
		 * 
		 */
		public function continueFadeOut():void
		{
			this.state = FADE_OUT;
		}
		
		
		/**
		 * 开始播放
		 * 
		 */
		public function start():void
		{
			state = FADE_IN;
		}
		
		/**
		 * 销毁
		 * 
		 */
		public function destory() : void
		{
			if (currentTransition == this)
				currentTransition = null;
			
			if (resultAtEnd)
				dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
