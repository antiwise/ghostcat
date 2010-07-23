package ghostcat.util
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import ghostcat.events.TickEvent;
	import ghostcat.util.core.Singleton;

	[Event(name="tick",type="ghostcat.events.TickEvent")]
	
	/**
	 * 这个类提供了发布ENTER_FRAME事件的功能，唯一的区别在于在发布的事件里会包含一个interval属性，表示两次事件的间隔毫秒数。
	 * 利用这种机制，接收事件方可以根据interval来动态调整动画播放间隔，单次移动距离，以此实现动画在任何客户机上的恒速播放，
	 * 不再受ENTER_FRAME发布频率的影响，也就是所谓的“跳帧”。
	 * 
	 * GMovieClip便是一个实现实例。
	 * 
	 * 相比其他同样利用getTimer()的方式，这种方法并不会进行多余的计算。
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class Tick extends Singleton
	{
		private var displayObject:Sprite;//用来提供事件的对象
		
		private var prevTime:int;//上次记录的时间
		
		static public function get instance():Tick
		{
			return Singleton.getInstanceOrCreate(Tick) as Tick;
		}
		
		/**
		 * 全局默认帧频
		 */
		static public var frameRate:Number = NaN;
		
		/**
		 * 最大两帧间隔（防止待机后返回卡死） 
		 */
		static public var MAX_INTERVAL:int = 3000;
		
		/**
		 * 速度系数
		 * 可由此实现慢速播放
		 *
		 */		
		public var speed:Number = 1.0;
		
		/**
		 * 是否停止发布Tick事件
		 * 
		 * Tick事件的发布影响的内容非常多，一般情况不建议设置此属性，而是设置所有需要暂停物品的pause属性。
		 */		
		public var pause:Boolean = false;
		
		public function Tick()
		{
			displayObject = new Sprite();
			displayObject.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		
		/**
		 * 重写方法使得默认使用弱引用监听，这样更接近ENTER_FRAME的用法
		 */
		public override function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=true):void
		{
			super.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		/**
		 * 清除掉积累的时间（在暂停之后）
		 * 
		 */
		public function clear():void
		{
			this.prevTime = 0;
		}
		
		private function enterFrameHandler(event:Event):void
		{
			var nextTime:int = getTimer();
			if (!pause)
			{
				var interval:int;
				if (prevTime == 0)
					interval = 0;
				else
				{
					interval = Math.min(nextTime - prevTime,MAX_INTERVAL);
					var e:TickEvent = new TickEvent(TickEvent.TICK);
					e.interval = interval * speed;
					dispatchEvent(e);
				}
			}
			prevTime = nextTime;
		}
	}
}
