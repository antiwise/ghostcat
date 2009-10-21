package ghostcat.display.transition
{
	import flash.display.DisplayObjectContainer;
	
	import ghostcat.events.MovieEvent;
	import ghostcat.display.movieclip.GMovieClip;

	/**
	 * 过渡动画类，用于处理场景切换
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TransitionAlphaLayer extends GMovieClip
	{
		public static const FADE_IN:String = "fade_in";
		public static const FADE_OUT:String = "fade_out";
		public static const WAIT:String = "wait";
		public static const END:String = "end";
		
		public static var currentTransition:TransitionAlphaLayer;
		
		/**
		 * 创建过渡动画到某个层
		 * 
		 * @param container	动画层所在的容器
		 * @param skin	动画皮肤
		 * @param switchHandler	切换时执行的函数
		 * @param fadeIn	进入时的动画名称数组
		 * @param fadeOut	消去时的动画名称数组
		 * @param waitAnimate	等待时的动画名称，将会循环播放。如果设置了这个值，除非外部手动设置state属性，否则动画永远不会停止。
		 * @return 
		 * 
		 */
		public static function createTo(container:DisplayObjectContainer,skin:*,switchHandler:Function,fadeIn:Array = null,fadeOut:Array = null,waitAnimate:String=null):TransitionAlphaLayer
		{
			var mc:TransitionAlphaLayer = new TransitionAlphaLayer(skin,switchHandler,fadeIn,fadeOut,waitAnimate);
			container.addChild(mc);
			mc.start();
			
			currentTransition = mc;
			return mc;
		}
		
		/**
		 * 让动画进入到消去状态。设置了waitAnimate时可执行此方法退出等待状态
		 * 
		 */
		public static function continueFadeOut():void
		{
			currentTransition.state = FADE_OUT;
		}
		
		/**
		 * 切换屏幕时执行的方法
		 */
		public var switchHandler:Function;
		
		/**
		 * 进入时的动画名称数组
		 */
		public var fadeIn:Array;
		
		/**
		 * 等待时的动画名称，将会循环播放。如果设置了这个值，除非外部手动设置state属性，否则动画永远不会停止。
		 */
		public var waitAnimate:String;
		
		/**
		 * 消去时的动画名称数组，完毕后将会删除自身
		 */
		public var fadeOut:Array;
		
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
					if (waitAnimate)
						setLabel(waitAnimate,-1);
					else
						state = FADE_OUT;
					switchHandler();
					break;
				case FADE_OUT:
					playAnimate(fadeOut,END);
					break;
				case END:
					destory();
					break;
			}
		}

		public function TransitionAlphaLayer(skin:*,switchHandler:Function,fadeIn:Array = null,fadeOut:Array = null,waitAnimate:String=null)
		{
			super(skin);
			
			this.fadeIn = fadeIn;
			this.fadeOut = fadeOut;
			this.waitAnimate = waitAnimate;
		}
		
		private function playAnimate(list:Array,nextState:String):void
		{
			if (list)
			{
				setLabel(list[0],1);
				for (var i:int = 1;i < list.length; i++)
					queueLabel(list[i],1);
				
				addEventListener(MovieEvent.MOVIE_EMPTY,animateEmptyHandler);
			}
			else
				state = nextState;
		
			function animateEmptyHandler(event:MovieEvent):void
			{
				removeEventListener(MovieEvent.MOVIE_EMPTY,animateEmptyHandler);
				state = nextState;
			}
		}
		
		/**
		 * 开始播放
		 * 
		 */
		public function start():void
		{
			state = FADE_IN;
		}
		/** @inheritDoc*/
		public override function destory() : void
		{
			super.destory();
			
			if (currentTransition == this)
				currentTransition = null;
		}
	}
}