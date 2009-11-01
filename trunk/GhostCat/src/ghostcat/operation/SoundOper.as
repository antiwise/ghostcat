package ghostcat.operation
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	
	import ghostcat.debug.Debug;
	
	[Event(name="complete",type="flash.events.Event")]
	
	/**
	 * 播放声音
	 * @author flashyiyi
	 * 
	 */
	public class SoundOper extends Oper
	{
		public static var urlBase:String = "";
		
		/**
		 * 数据源 
		 */
		public var source:*;
		
		/**
		 * 播放的声音
		 */
		public var channel:SoundChannel;
		
		/**
		 * 声音开始时间 
		 */
		public var startTime:int;
		
		/**
		 * 循环次数，-1位无限循环
		 */
		public var loops:int;
		
		/**
		 * 是否在全部下载完毕后才播放
		 */
		public var playWhenComplete:Boolean;
		
		/**
		 * 声音缓动队列
		 */
		public var tweenQueue:Queue;
		
		private var _soundTransform:SoundTransform;
		
		/**
		 * 声音滤镜对象
		 * @param v
		 * 
		 */
		public function set soundTransform(v:SoundTransform):void
		{
			if (channel)
				channel.soundTransform = v;
			else
				_soundTransform = v;
		}
		
		public function get soundTransform():SoundTransform
		{
			if (channel)
				return channel.soundTransform;
			else
				return _soundTransform;
		}
		
		public function SoundOper(source:* = null,playWhenComplete:Boolean = true,startTime:int = 0,loops:int = 1,volume:Number = 1.0,panning:Number = 0.5)
		{
			this.source = source;
			this.playWhenComplete = playWhenComplete;
			this.startTime = startTime;
			this.loops = loops;
			this.soundTransform = new SoundTransform(volume,panning);
		}
		
		/**
		 * 增加一个声音缓动
		 * 
		 * @param delay	起始时间
		 * @param duration	持续时间
		 * @param volume	音量
		 * @param pan	声道均衡
		 * @param ease	缓动函数
		 * 
		 */
		public function addTween(duration:int = 1000,volume:Number = NaN,pan:Number = NaN,ease:Function = null):void
		{
			if (!tweenQueue)
				tweenQueue = new Queue();
			
			var o:Object = new Object();
			if (!isNaN(volume))
				o.volume = volume;
			if (!isNaN(pan))
				o.pan = pan;
			if (ease != null)
				o.ease = ease;
			
			tweenQueue.children.push(new TweenOper(this,duration,o));
		}
		
		/** @inheritDoc*/
		public override function execute() : void
		{
			super.execute();
			if (source is String)
			{
				try
				{
					source = getDefinitionByName(source);
				}
				catch (e:Error)
				{}
			}
			
			if (source is Class)
				source = new source();
			
			if (!(source is Sound))
			{
				var s:Sound = new Sound();
				s.addEventListener(IOErrorEvent.IO_ERROR,fault);
				s.addEventListener(Event.COMPLETE,loadSoundComplete);
				s.load(new URLRequest(urlBase + source),new SoundLoaderContext(1000,true));
				source = s;
				if (playWhenComplete)
					return;
			}
			
			if (source is Sound)
				playSound(source as Sound)
			else
				Debug.error("数据源格式错误")	
		}
		
		private function loadSoundComplete(event:Event):void
		{
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR,fault);
			event.currentTarget.removeEventListener(Event.COMPLETE,loadSoundComplete);
			
			dispatchEvent(event);
			
			if (playWhenComplete)
				playSound(source as Sound);
		}
		
		/**
		 * 播放声音
		 *  
		 * @param s
		 * @return 
		 * 
		 */
		protected function playSound(s:Sound):SoundChannel
		{
			channel = s.play(startTime,(loops >= 0) ? loops : int.MAX_VALUE,soundTransform);
			channel.addEventListener(Event.SOUND_COMPLETE,result);
			
			if (tweenQueue)
				tweenQueue.execute();
			
			return channel;
		}
		/** @inheritDoc*/
		public override function result(event:* = null):void
		{
			channel.removeEventListener(Event.SOUND_COMPLETE,result);
			super.result(event);
		}
		/** @inheritDoc*/
		public override function fault(event:* = null):void
		{
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR,fault);
			event.currentTarget.removeEventListener(Event.COMPLETE,loadSoundComplete);
			if (channel)
				channel.removeEventListener(Event.SOUND_COMPLETE,result);
			
			super.result(event);
		}
	}
}