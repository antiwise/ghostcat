package ghostcat.util
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.utils.setTimeout;
	
	import ghostcat.events.TickEvent;
	import ghostcat.events.TweenEvent;
	import ghostcat.util.easing.Linear;

	[Event(name="tween_start",type="ghostcat.events.TweenEvent")]
	[Event(name="tween_end",type="ghostcat.events.TweenEvent")]
	[Event(name="tween_update",type="ghostcat.events.TweenEvent")]
	
	/**
	 * 内部使用的Tween，用法基本和TweenLite相同
	 * 依赖于Tick。Tick变速和暂停也会影响到这里。
	 * 
	 * 增加属性：
	 * pan，将会改变声音的声道分配
	 * tint2，将会以附加的方法增加颜色
	 * dynamicPoint，是一个显示对象，将会以它的x,y属性作为Tween的终点。这两个值在过程中可变化追踪
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TweenUtil extends EventDispatcher
	{
		Tick.instance.addEventListener(TickEvent.TICK,tickHandler);//被引用时自动初始化
		
		private static var effects:Array = [];
		
		/**
		 * 是否在执行onUpdate回调函数的时候带上currentTime/duration的系数作为参数
		 */
		public static var updateWithCurrentTime:Boolean = false;
		
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
			new TweenUtil({},duration,{onComplete: new Handler(handler,para).toFunction()})
		}
		
		/**
		 * 添加缓动效果
		 *  
		 * @param target	目标对象
		 * @param duration	缓动时间，以毫秒为单位
		 * @param params	参数，比如：{x:50, alpha:1, delay:300, onComplete:function, ease:Function}
		 * 基本和TweenLite相同，选了几个我需要用的东西，诸如volume,pan,frame,"-100"相对坐标模式也还在
		 */		
		public static function to(target:Object, duration:int, params:Object):TweenUtil
		{
			return new TweenUtil(target,duration,params);
		}
		
		/**
		 * 反向播放
		 *  
		 * @param target	目标对象
		 * @param duration	缓动时间，以毫秒为单位
		 * @param params	参数
		 * 
		 */
		public static function from(target:Object, duration:int, params:Object):TweenUtil
		{
			params.invert = true;
			return new TweenUtil(target,duration,params);
		}
		
		/**
		 * 是否反向播放
		 */
		public var invert:Boolean =false;
		/**
		 * 是否已开始
		 */
		public var started:Boolean = false;
		/**
		 * 是否暂停
		 */
		public var paused:Boolean = false;
		/**
		 * 目标
		 */
		public var target:* = target;
		/**
		 * 开始时间
		 */
		public var currentTime:int;
		/**
		 * 缓动时间长度
		 */
		public var duration:int;
		/**
		 * 缓动函数
		 */
		public var ease:Function;
		/**
		 * 起始值
		 */
		public var fromValues:Object = new Object();
		/**
		 * 结束值
		 */
		public var toValues:Object = new Object();
		/**
		 * 开始Tween的回调函数
		 */
		public var onStart:Function;
		/**
		 * 更新Tween的回调函数
		 */
		public var onUpdate:Function;
		/**
		 * 完成Tween的回调函数
		 */
		public var onComplete:Function;
		/**
		 * 是否在倒放最开始的时候显示初值
		 */
		public var renderOnStart:Boolean;
		
		public function TweenUtil(target:Object, duration:int, params:Object)
		{
			this.target = target;
			this.duration = duration;
			
			for (var key:String in params)
			{
				switch (key)
				{
					case "ease":
					case "invert":
					case "renderOnStart":
					case "onStart":
					case "onUpdate":
					case "onComplete":
						this[key] = params[key];
						break;
					case "delay":
						this.currentTime = -params[key];
						break;
					case "volume":
					case "pan":
						this.fromValues[key] = target["soundTransform"][key];
						this.toValues[key] = params[key];
						break;
					case "frame":
						this.fromValues[key] = (target as MovieClip).currentFrame;
						this.toValues[key] = params[key];
						break;
					case "tint":
					case "tint2":
						this.fromValues[key] = (target as DisplayObject).transform.colorTransform.color & 0xFFFFFF;
						this.toValues[key] = params[key];
						break;
					case "dynamicPoint":
						this.fromValues[key] = new Point((target as DisplayObject).x, (target as DisplayObject).y)
						this.toValues[key] = params[key];
						break;
					default :
						this.fromValues[key] = target[key];
						this.toValues[key] = params[key];
						break;
				}				
				//转换x:"-100"的相对坐标模式
				if (this.toValues[key] is String)
					this.toValues[key] = this.fromValues[key] + Number(this.toValues[key]);
			}
			if (this.ease == null)
				this.ease = Linear.easeOut;
			
			effects.push(this);
		}
		
		private static function tickHandler(event:TickEvent):void
		{
			update(event.interval);
		}
		
		public static function update(interval:int=0):void 
		{
			for (var i:int = effects.length - 1; i >=0; i--) 
			{
				var $o:TweenUtil = effects[i] as TweenUtil;
				$o.update(interval);
			}
		}
		
		public function update(interval:int=0):void
		{
			var key:String;
				
			//倒放时初值显示
			if (this.invert && this.renderOnStart)
			{	
				for (key in this.toValues)
					updateValue(this.target,key,this.toValues[key])
				this.renderOnStart = false;
			}
			
			if (this.paused)
				return;
			
			this.currentTime += interval;
			if (this.currentTime < 0)
				return;
			
			//判断是否是第一次
			if (!this.started) 
			{
				this.started = true;
				
				if (this.onStart!=null)
					this.onStart();
				
				this.dispatchEvent(new TweenEvent(TweenEvent.TWEEN_START));
			}
			
			//更新属性
			if (this.currentTime >= this.duration)
			{
				for (key in this.toValues)
				{
					updateValue(this.target,key,(this.invert)?this.fromValues[key]:this.toValues[key]);
				}
			}
			else 
			{
				for (key in this.toValues)
				{
					var t:int = (this.invert)?(this.duration - this.currentTime):this.currentTime;
					var newValue:* = calculateValue(this,t,key);
					updateValue(this.target,key,newValue);
				}
			}
			
			//执行更新回调函数
			if (this.onUpdate!=null)
			{
				if (updateWithCurrentTime)
					this.onUpdate(this.currentTime/this.duration);
				else
					this.onUpdate();
				
				this.dispatchEvent(new TweenEvent(TweenEvent.TWEEN_UPDATE));
			}
			
			//如果已经结束则执行结束回调函数并删除
			if (this.currentTime >= this.duration)
			{
				if (this.onComplete!=null)
					this.onComplete();
				
				effects.splice(effects.indexOf(this), 1);
				
				this.dispatchEvent(new TweenEvent(TweenEvent.TWEEN_END));
			}
		}
		
		private static function calculateValue($o:TweenUtil,t:int,key:String):*
		{
			var a:* = $o.fromValues[key];
			var b:* = $o.toValues[key];
			if (a is Point)
			{
				return new Point($o.ease(t, a.x, b.x -  a.x, $o.duration),
									$o.ease(t, a.y, b.y -  a.y, $o.duration))
			}
			else if (a is Rectangle)
			{
				return new Rectangle($o.ease(t, a.x, b.x -  a.x, $o.duration),
									$o.ease(t, a.y, b.y -  a.y, $o.duration),
									$o.ease(t, a.width, b.width -  a.width, $o.duration),
									$o.ease(t, a.height, b.height -  a.height, $o.duration))
			}
			else if (key == "tint" || key == "tint2")
			{
				var r1:int = (a >> 16) & 0xFF;
				var g1:int = (a >> 8) & 0xFF;
				var b1:int = a & 0xFF;
				var r2:int = (b >> 16) & 0xFF;
				var g2:int = (b >> 8) & 0xFF;
				var b2:int = b & 0xFF;
				var r3:int = MathUtil.limitIn($o.ease(t, r1, r2 -  r1, $o.duration),0,0xFF);
				var g3:int = MathUtil.limitIn($o.ease(t, g1, g2 -  g1, $o.duration),0,0xFF);
				var b3:int = MathUtil.limitIn($o.ease(t, b1, b2 -  b1, $o.duration),0,0xFF);
				return ColorUtil.RGB(r3, g3, b3);
			}
			return $o.ease(t, a, b -  a, $o.duration)
		}
		
		private static function updateValue(target:*,key:String,value:*):void
		{
			switch (key)
			{
				case "volume": 
				case "pan":
					var soundTrans:SoundTransform = target["soundTransform"];
					soundTrans[key] = value;
					target["soundTransform"] = soundTrans;
					break;
				case "frame":
					(target as MovieClip).gotoAndStop(int(value))
					break;
				case "tint":
					(target as DisplayObject).transform.colorTransform = ColorUtil.getColorTransform(value as uint);
					break;
				case "tint2":
					(target as DisplayObject).transform.colorTransform = ColorUtil.getColorTransform2(value as uint);
					break;
				case "dynamicPoint":
					(target as DisplayObject).x = value.x;
					(target as DisplayObject).y = value.y;
					break;
				default:
					target[key] = value;
					break;
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
				var $o:TweenUtil = effects[i] as TweenUtil;
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
		 * 获取Tween
		 * 
		 * @param target
		 * 
		 */
		public static function getTween(target:Object):Array
		{
			var result:Array = [];
			for each(var $o:TweenUtil in effects)
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
			for each(var $o:TweenUtil in effects)
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
			for each(var $o:TweenUtil in effects)
			{
				if ($o.target == target)
					$o.paused = false;
			}
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
				for each(var $o:TweenUtil in effects)
					$o.duration = 0;
					
				update();
			}
			else 
				effects = [];
		}
	}
}