package ghostcat.media
{
	import flash.events.SampleDataEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.utils.Timer;
	import flash.utils.setTimeout;

	/**
	 * 蜂呤音乐类
	 * @author flashyiyi
	 * 
	 */
	public class BeepMusic
	{
		private static const HZS:Array = [24.7,27.7,31.1,33.0,37.0,41.5,46.6];
			
		public var data:String;
		public var position:int = 0;
		public var loop:int;
		
		private var timer:Timer;
		private var hz:Number;
		private var snd:Sound;
		
		private var loopCount:int;
		
		
		/**
		 * 获得音对应的频率 
		 * @param v
		 * 
		 */
		public static function getMHZ(v:String):int
		{
			var a:int = v.charCodeAt(0) - 65;
			var b:int = v.charCodeAt(1) - 49;
			if (b < 0 || b > 8)
				return 0
			else
				return HZS[b] * Math.pow(2,a);
		}
		
		public function BeepMusic(data:String):void
		{
			this.data = data;
			
			this.timer = new Timer(125,1000);
			this.timer.addEventListener(TimerEvent.TIMER,timerHandler);
		}
		
		public function play(loop:int = 1):void
		{
			this.loop = loop;
			this.loopCount = 0;
			this.position = 0;
			this.hz = 0;
			timer.start();
			
			snd = new Sound();
			snd.addEventListener(SampleDataEvent.SAMPLE_DATA,sampleDataHandler);
			snd.play();
		}
		
		private function timerHandler(event:TimerEvent):void
		{
			var p:int = position * 2;
			if (p < data.length)
			{
				var s:String = data.substr(p,2);
				if (s != "--")
				{
					var curHz:int = getMHZ(s);
					if (curHz == this.hz)
					{
						this.hz = 0;
						setTimeout(function ():void{
							hz = curHz;
						},20);
					}
					else
					{
						this.hz = curHz;
					}
				}
			}
			else
			{
				this.hz = NaN;
			}
			
			position++;
		}
		
		public function stop():void
		{
			timer.stop();
			
			snd.removeEventListener(SampleDataEvent.SAMPLE_DATA,sampleDataHandler);
			snd = null;
		}
		
		private function sampleDataHandler(event:SampleDataEvent):void
		{
			if (isNaN(hz))
			{
				loopCount++;
				if (loopCount >= loop)
				{
					stop();
					return;
				}
				else
				{
					this.hz = 0;
					this.position = 0;		
				}
			}
			
			var v:Number = hz / 44.1;
			for (var c:int = 0; c < 2048; c++ )
			{
				event.data.writeFloat(Math.sin(Number(c + event.position) / Math.PI / 2 * v) * 0.25);
				event.data.writeFloat(Math.sin(Number(c + event.position) / Math.PI / 2 * v) * 0.25);
			}
		}
	}
}