package ghostcat.media
{
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
		public static function playBytes(bytes:ByteArray):SoundChannel
		{
			var s:Sound = new Sound();
			s.addEventListener(SampleDataEvent.SAMPLE_DATA,sampleDataHandler);
			return s.play();
			
			function sampleDataHandler(event:SampleDataEvent):void
			{
				if (!bytes.bytesAvailable)
				{
					s.removeEventListener(SampleDataEvent.SAMPLE_DATA,sampleDataHandler);
					return;
				}
				
				for (var i:int = 0; i < 8192 && bytes.bytesAvailable; i++) 
				{
					var sample:Number = bytes.readFloat();
					event.data.writeFloat(sample);
					event.data.writeFloat(sample);
				}
			}
		}
		
		/**
		 * 变速播放 
		 * @param targetSound
		 * @param speed
		 * @return 
		 * 
		 */
		public static function playSpeed(targetSound:Sound,speed:Number = 1.0,multiple:int = 2):SoundChannel
		{
			var samplesData:ByteArray = new ByteArray();
			var position:int = 0;
			
			var s:Sound = new Sound();
			s.addEventListener(SampleDataEvent.SAMPLE_DATA,sampleDataHandler);
			return s.play();
			
			function sampleDataHandler(event:SampleDataEvent):void
			{
				try
				{
					samplesData.position = samplesData.length;
					targetSound.extract(samplesData, 2048 * multiple);
					
					for (var i:int = 0 ;i < 2048; i++)
					{
						samplesData.position = position * 8;
						
						var left:Number = samplesData.readFloat()
						event.data.writeFloat(samplesData.readFloat());
						if (multiple == 2)
							event.data.writeFloat(samplesData.readFloat());
						else
							event.data.writeFloat(left);
							
						position = position + speed;
					}
				}
				catch (e:Error)
				{
					s.removeEventListener(SampleDataEvent.SAMPLE_DATA,sampleDataHandler);
				}
			}
		}
		
		/**
		 * 发出固定频率的声音 
		 * @param v
		 * @param len
		 * @return 
		 * 
		 */
		public static function beep(v:Number = 1.0,len:int = 10):SoundChannel
		{
			var t:int = getTimer();
			var s:Sound = new Sound();
			s.addEventListener(SampleDataEvent.SAMPLE_DATA,sampleDataHandler);
			return s.play();
			
			function sampleDataHandler(event:SampleDataEvent):void
			{
				if (getTimer() - t > len)
				{
					s.removeEventListener(SampleDataEvent.SAMPLE_DATA,sampleDataHandler);
					return;
				}
				
				for (var c:int=0; c < 8192; c++ )
				{
					event.data.writeFloat(Math.sin(Number(c + event.position) / Math.PI / 2 * v) * 0.25);
					event.data.writeFloat(Math.sin(Number(c + event.position) / Math.PI / 2 * v) * 0.25);
				}
			}
		}
	}
}