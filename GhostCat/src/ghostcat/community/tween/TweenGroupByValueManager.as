package ghostcat.community.tween
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import ghostcat.community.GroupManager;
	import ghostcat.util.Util;
	import ghostcat.util.easing.TweenUtil;

	/**
	 * Tween可控群组执行
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TweenGroupByValueManager extends GroupManager
	{
		/**
		 * 每个动画的执行时间
		 */
		public var duration:int;
		
		/**
		 * 缓动参数
		 */
		public var params:Object;
		
		private var _percent:Number = 0;
		
		/**
		 * 是否在倒放开始时即确认Tween属性
		 */
		public var renderOnStart:Boolean = true;
		
		public function TweenGroupByValueManager(duration:int,params:Object)
		{
			this.duration = duration;
			this.params = params;
			
			super(tweenCommand);
		}
		
		/**
		 * 启动进度
		 */
		public function get percent():Number
		{
			return _percent;
		}

		public function set percent(value:Number):void
		{
			_percent = value;
			calculateAll();
		}
		
		private var tweens:Dictionary;
		
		/**
		 * 开始 
		 * 
		 */
		public function start():void
		{
			tweens = new Dictionary();
			for each (var child:DisplayObject in data)
			{
				var o:Object = Util.copy(params);
				if (renderOnStart)
					o.renderOnStart = true;
				
				var tween:TweenUtil = TweenUtil.to(child,duration,o);
				tween.update();
				tween.paused = true;
				
				tweens[child] = tween;
			}
			percent = 0;
		}

		/**
		 * 执行缓动
		 * @param v
		 * 
		 */
		protected function tweenCommand(v:DisplayObject):void
		{
			var tween:TweenUtil = tweens[v];
			if (!tween)
				return;
			
			var p:Number = data.indexOf(v) / (data.length - 1);
			tween.paused = (p > percent);
		}
	}
}