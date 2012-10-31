package ghostcat.game.util
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	
	import ghostcat.events.TickEvent;
	import ghostcat.util.MathUtil;
	import ghostcat.util.Tick;
	import ghostcat.util.core.Handler;
	import ghostcat.util.display.ColorUtil;
	import ghostcat.util.easing.Linear;
	import ghostcat.util.easing.TweenEvent;
	import ghostcat.util.easing.TweenUtil;
	
	public class GameTweenUtil extends TweenUtil
	{
		GameTick.instance.addEventListener(TickEvent.TICK,tickHandler);//被引用时自动初始化
		
		private static var effects:Array = [];
		
		
		/**
		 * 延迟执行某个函数，但最早也只会在下一帧执行。
		 * 
		 * @param handler	函数
		 * @param para	函数参数
		 * @param duration	等待时间
		 * 
		 */		
		public static function callLater(handler:Function,para:Array=null,duration:int = 0):void
		{
			new GameTweenUtil({},duration,{onComplete: new Handler(handler,para).toFunction()})
		}
		
		/**
		 * 添加缓动效果
		 *  
		 * @param target	目标对象
		 * @param duration	缓动时间，以毫秒为单位
		 * @param params	参数，比如：{x:50, alpha:1, delay:300, onComplete:function, ease:Function}
		 * 基本和TweenLite相同，选了几个我需要用的东西，诸如volume,pan,frame,"-100"相对坐标模式也还在
		 */		
		public static function to(target:Object, duration:int, params:Object):GameTweenUtil
		{
			return new GameTweenUtil(target,duration,params);
		}
		
		/**
		 * 反向播放
		 *  
		 * @param target	目标对象
		 * @param duration	缓动时间，以毫秒为单位
		 * @param params	参数
		 * 
		 */
		public static function from(target:Object, duration:int, params:Object):GameTweenUtil
		{
			params.invert = true;
			return new GameTweenUtil(target,duration,params);
		}
		
		/**
		 * 返回一个暂停的Tween对象（不进行播放，可用calculateValue取得某个时间内的特定值）
		 *  
		 * @param target
		 * @param duration
		 * @param params
		 * @return 
		 * 
		 */
		public static function test(target:Object, duration:int, params:Object, key:String, t:int):GameTweenUtil
		{
			return new GameTweenUtil(target,duration,params,false);
		}
		
		public function GameTweenUtil(target:Object, duration:int, params:Object, autoStart:Boolean = true)
		{
			super(target,duration,params,autoStart);
		}
		
		protected override function get effects():Array
		{
			return GameTweenUtil.effects;
		}
		
		private static function tickHandler(event:TickEvent):void
		{
			update(event.interval);
		}
		
		/**
		 * 立即更新全部缓动
		 * @param interval
		 * 
		 */
		public static function update(interval:int=0):void 
		{
			for (var i:int = effects.length - 1; i >=0; i--) 
			{
				var $o:GameTweenUtil = effects[i] as GameTweenUtil;
				if ($o)
					$o.update(interval);
			}
		}
		
		/**
		 * 获取Tween
		 * 
		 * @param target
		 * 
		 */
		public static function getTween(target:Object):Array
		{
			var result:Array = [];
			for each(var $o:GameTweenUtil in effects)
			{
				if ($o.target == target)
					result.push($o);
			}
			return result;
		}
		
		/**
		 * 暂停缓动
		 * 
		 * @param target
		 * @param submitEffect	是否让当前缓动效果生效
		 * 
		 */
		public static function pauseTween(target:Object,submitEffect:Boolean = true):void
		{
			for each(var $o:GameTweenUtil in effects)
			{
				if ($o.target == target)
					$o.paused = true;
			}
			if (submitEffect) 
				update();
		}
		
		/**
		 * 继续缓动
		 * 
		 * @param target
		 * 
		 */
		public static function continueTween(target:Object):void
		{
			for each(var $o:GameTweenUtil in effects)
			{
				if ($o.target == target)
					$o.paused = false;
			}
		}
		
		/**
		 * 移除对target的所有缓动效果
		 *  
		 * @param target			目标对象
		 * @param submitEffect		是否让当前缓动效果生效
		 * 
		 */		
		public static function removeTween(target:Object, submitEffect:Boolean = true):void
		{
			for (var i:int = effects.length - 1; i >=0 ; i--)
			{
				var $o:GameTweenUtil = effects[i] as GameTweenUtil;
				if ($o.target == target)
				{
					if (submitEffect)
						$o.duration = 0;
					else 
						effects.splice(i, 1);
				}
			}
			if (submitEffect) 
				update();
		}
		
		/**
		 * 移除所有缓动 
		 * 
		 * @param submitEffect	是否让当前缓动效果生效
		 * 
		 */
		public static function removeAllTween(submitEffect:Boolean = true):void 
		{
			if (submitEffect) 
			{ 
				for each(var $o:GameTweenUtil in effects)
					$o.duration = 0;
				
				update();
			}
			else 
				effects = [];
		}
		
		/**
		 * 检查是否有某个值的缓动
		 *  
		 * @param target
		 * @param key
		 * @return 
		 * 
		 */
		public static function hasKey(target:Object,key:String):Boolean
		{
			for each (var t:GameTweenUtil in getTween(target))
			{
				return t.toValues.hasOwnProperty(key);
			}
			return false;
		}
	}
}