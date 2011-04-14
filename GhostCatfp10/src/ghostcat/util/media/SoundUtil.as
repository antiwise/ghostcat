package ghostcat.util.media
{
	import flash.events.Event;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	/**
	 * 声音类 
	 * @author flashyiyi
	 * 
	 */
	public final class SoundUtil
	{
		/**
		 * 播放二进制数据 
		 * @param bytes
		 * @return 
		 * 
		 */
		public static function playBytes(samplesData:ByteArray,loop:int = 1,speed:Number = 1.0,multiple:int = 2):SoundChannel
		{
			samplesData.position = 0;
			var position:Number = 0;
			var loopCount:int = 0;
			
			var s:Sound = new Sound();
			s.addEventListener(SampleDataEvent.SAMPLE_DATA,sampleDataHandler);
			var channel:SoundChannel = s.play();
			return channel;
			
			function sampleDataHandler(event:SampleDataEvent):void
			{
				if ((position + 2048 * speed) * 4 * multiple >= samplesData.length)
				{
					loopCount++;
					if (loopCount < loop)
					{
						position = 0;
					}
					else
					{
						s.removeEventListener(SampleDataEvent.SAMPLE_DATA,sampleDataHandler);
						channel.dispatchEvent(new Event(Event.SOUND_COMPLETE));
						return;
					}
				}	
				
				for (var i:int = 0 ;i < 2048; i++)
				{
					samplesData.position = int(position) * 4 * multiple;
					
					var left:Number = samplesData.readFloat();
					event.data.writeFloat(left);
					event.data.writeFloat(multiple == 2 ? samplesData.readFloat() : left);
					
					position = position + speed;
				}
			}
		}
		
		/**
		 * 播放Sound对象 
		 * @param targetSound
		 * @param loop
		 * @param speed
		 * @param multiple
		 * @return 
		 * 
		 */
		public static function play(targetSound:Sound,loop:int = 1,speed:Number = 1.0,multiple:int = 2):SoundChannel
		{
			var samplesData:ByteArray = new ByteArray();
			var position:Number = 0;
			var loopCount:int = 0;
			
			var s:Sound = new Sound();
			s.addEventListener(SampleDataEvent.SAMPLE_DATA,sampleDataHandler);
			var channel:SoundChannel = s.play();
			return channel;
			
			function sampleDataHandler(event:SampleDataEvent):void
			{
				samplesData.position = samplesData.length;
				targetSound.extract(samplesData, 2048 * multiple);
					
				try
				{
					for (var i:int = 0 ;i < 2048; i++)
					{
						samplesData.position = int(position) * 4 * multiple;
						
						var left:Number = samplesData.readFloat();
						event.data.writeFloat(left);
						event.data.writeFloat(multiple == 2 ? samplesData.readFloat() : left);
							
						position = position + speed;
					}
				}
				catch (e:Error)
				{
					loopCount++;
					if (loopCount < loop)
					{
						position = 0;
						sampleDataHandler(event);
					}
					else
					{
						s.removeEventListener(SampleDataEvent.SAMPLE_DATA,sampleDataHandler);
						channel.dispatchEvent(new Event(Event.SOUND_COMPLETE));
						return;
					}
				}
			}
		}
		
		/**
		 * 发出固定频率的声音 
		 * @param mhz	频率（mhz）
		 * @param len
		 * @return 
		 * 
		 */
		public static function beep(mhz:Number = 44.1,len:int = 10):SoundChannel
		{
			var v:Number = mhz / 44.1;
			var t:int = getTimer();
			var s:Sound = new Sound();
			s.addEventListener(SampleDataEvent.SAMPLE_DATA,sampleDataHandler);
			var channel:SoundChannel = s.play();
			return channel;
			
			function sampleDataHandler(event:SampleDataEvent):void
			{
				if (getTimer() - t > len && len >= 0)
				{
					s.removeEventListener(SampleDataEvent.SAMPLE_DATA,sampleDataHandler);
					channel.dispatchEvent(new Event(Event.SOUND_COMPLETE));
					return;
				}
				
				for (var c:int = 0; c < 2048; c++ )
				{
					event.data.writeFloat(Math.sin(Number(c + event.position) / Math.PI / 2 * v) * 0.25);
					event.data.writeFloat(Math.sin(Number(c + event.position) / Math.PI / 2 * v) * 0.25);
				}
			}
		}
	}
}