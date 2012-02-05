package ghostcat.util.sound
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	import ghostcat.util.easing.TweenUtil;
	
	public class BackgroundSound extends EventDispatcher
	{
		public var url:String;
		public var sound:Sound;
		public var channel:SoundChannel;
		public var loopStart:int;
		
		private var _volume:Number;

		public function get volume():Number
		{
			return _volume;
		}

		public function set volume(value:Number):void
		{
			_volume = value;
			
			if (channel)
				channel.soundTransform = new SoundTransform(value);
		}

		
		public function BackgroundSound()
		{
		}
		
		public function setVolume(volume:Number,len:Number = 1000):void
		{
			TweenUtil.removeTween(this,false);
			TweenUtil.to(this,len,{volume:volume});
		}
		
		public function playBgSound(url:String,len:int = 1000):void
		{
			if (this.url == url)
				return;
			
			this.url = url
			
			stop();
			
			sound = new Sound(new URLRequest(url),new SoundLoaderContext(1000,true));
			
			channel = sound.play(0,1);
			if (!channel)
				return;
			
			channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteListener);
			
			this.volume = 0.0;
			
			TweenUtil.removeTween(this,false);
			TweenUtil.to(this,len,{volume:1.0});
		}
		
		private function soundCompleteListener(evt:Event):void
		{
			if (channel)
			{
				channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteListener);
				channel = sound.play(loopStart,1,channel.soundTransform);
				channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteListener);
			}
		}
		
		public function stop(dur:int = 1000):void
		{
			if (sound)
			{
				try
				{
					sound.close();	
				} 
				catch(error:Error){	};
			
				sound = null;
			}
			if (channel)
			{
				channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteListener);
				TweenUtil.removeTween(channel,false);
				TweenUtil.to(channel,dur,{volume:0.0,onComplete:channel.stop});
				channel = null;
			}
		}
	}
}