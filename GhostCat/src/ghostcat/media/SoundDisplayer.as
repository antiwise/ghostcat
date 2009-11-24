package ghostcat.media
{
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	
	import ghostcat.display.GNoScale;
	import ghostcat.events.TickEvent;

	public class SoundDisplayer extends GNoScale
	{
		public function SoundDisplayer(width:Number,height:Number)
		{
			this.width = width;
			this.height = height;
			this.enabledTick = true;
		}
		
		protected override function tickHandler(event:TickEvent):void
		{
			var bytes:ByteArray = new ByteArray()
			SoundMixer.computeSpectrum(bytes);
			
			var leftChannel:Array = [];
			var rightChannel:Array = [];
			var i:int;
			for (i = 0;i < 256; i++)
				leftChannel.push(bytes.readFloat());
			for (i = 0;i < 256; i++)
				rightChannel.unshift(bytes.readFloat());
			
			doWithSpectrum(leftChannel,rightChannel);
		}
		
		protected function doWithSpectrum(leftChannel:Array,rightChannel:Array):void
		{
			const PLOT_HEIGHT:int = height / 2;
			var dx:Number = width / 256;
			var i:int = 0;
			
			graphics.clear();
			
			graphics.lineStyle(0, 0x6600CC);
			graphics.moveTo(0, PLOT_HEIGHT);
			for (i = 0; i < 256; i++)
				graphics.lineTo(i * dx, PLOT_HEIGHT - leftChannel[i] * PLOT_HEIGHT);
			graphics.lineTo(256 * dx, PLOT_HEIGHT);
			graphics.endFill();
			
			graphics.lineStyle(0, 0xCC0066);
			graphics.moveTo(0 , PLOT_HEIGHT);
			for (i = 0; i < 256; i++)
				graphics.lineTo(i * dx, PLOT_HEIGHT - rightChannel[i] * PLOT_HEIGHT);
			graphics.lineTo(256 * dx, PLOT_HEIGHT);
			graphics.endFill();

		}
	}
}