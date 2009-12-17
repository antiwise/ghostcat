package 
{
	import ghostcat.display.GBase;
	import ghostcat.events.TickEvent;
	import ghostcat.util.ServiceDate;
	
	[SWF(width="200",height="200",backgroundColor="0x0")]
	
	public class GhostCatFP10Example extends GBase
	{
		public var time:ServiceDate = new ServiceDate(new Date().getTime());
		public function GhostCatFP10Example()
		{
			this.enabledTick = true;
		}
		
		protected override function tickHandler(event:TickEvent) : void
		{
			trace(new Date(),time.getDate())
		}
	}
}