package ghostcat.media
{
	import flash.events.Event;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.utils.ByteArray;

	public final class SoundUtil
	{
		public static function play(bytes:ByteArray):void
		{
			var s:Sound = new Sound();
			s.addEventListener(SampleDataEvent.SAMPLE_DATA,sampleDataHandler);
			s.play();
			
			function sampleDataHandler(event:SampleDataEvent):void
			{
				event.data.writeBytes(bytes);
			}
		}
		
		public static function beep(v:Number,len:int = 1000):void
		{
			var s:Sound = new Sound();
			s.addEventListener(SampleDataEvent.SAMPLE_DATA,sampleDataHandler);
			s.play();
			
			function sampleDataHandler(event:SampleDataEvent):void
			{
				for ( var c:int=0; c < len; c++ )
				{
					event.data.writeFloat(v);
					event.data.writeFloat(v);
				}

			}
		}
	}
}