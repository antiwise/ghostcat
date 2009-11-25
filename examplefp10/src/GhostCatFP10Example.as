package 
{
	import ghostcat.display.GBase;
	import ghostcat.display.viewport.Tile45;
	import ghostcat.events.TickEvent;
	import ghostcat.media.SoundUtil;
	
	[SWF(width="200",height="200",backgroundColor="0x0")]
	
	public class GhostCatFP10Example extends GBase
	{
		[Embed("p1.jpg")]
		public var p:Class;
		public var t:Tile45;
		public function GhostCatFP10Example()
		{
			SoundUtil.beep(0.5);
			

		}
		 
		protected override function tickHandler(event:TickEvent) : void
		{
			
			
		}
	}
}