package ghostcat.operation
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	
	import ghostcat.debug.Debug;

	/**
	 * 播放声音
	 * @author flashyiyi
	 * 
	 */
	public class SoundOper extends Oper
	{
		public static var urlBase:String = "";
		
		public var source:*;
		public var channel:SoundChannel;
		
		public var startTime:int;
		public var loops:int;
		public var sndTransform:SoundTransform;
		
		public function SoundOper(source:* = null,startTime:int = 0,loops:int = 1,sndTransform:SoundTransform = null)
		{
			this.source = source;
			this.startTime = startTime;
			this.loops = loops;
			this.sndTransform = sndTransform;
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
				
				if (!(source is Sound))
				{
					var s:Sound = new Sound();
					s.addEventListener(IOErrorEvent.IO_ERROR,fault);
					s.load(new URLRequest(urlBase + source),new SoundLoaderContext(1000,true));
					source = s;
				}
			}
			
			if (source is Sound)
				playSound(source as Sound)
			else
				Debug.error("数据源格式错误")	
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
			channel = s.play(startTime,loops,sndTransform);
			channel.addEventListener(Event.SOUND_COMPLETE,result);
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
			if (channel)
				channel.removeEventListener(Event.SOUND_COMPLETE,result);
			
			super.result(event);
		}
	}
}