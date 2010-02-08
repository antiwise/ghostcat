package ghostcat.display.residual
{
	import flash.utils.getTimer;
	
	import ghostcat.display.residual.ResidualScreen;
	import ghostcat.events.TickEvent;
	
	public class SleepResidualScreen extends ResidualScreen
	{
		private var sleepStartTime:int;
		public var sleepWait:int = 1000;
		public function SleepResidualScreen(width:int,height:int)
		{
			super(width,height);
			
			this.visible = false;
		}
		
		protected override function tickHandler(event:TickEvent) : void
		{
			if (!this.enabled)
				return;
			
			if (this.children.length == 0)
			{
				if (!sleepStartTime)
					sleepStartTime = getTimer();
				
				if (getTimer() - sleepStartTime > sleepWait)
				{
					this.visible = false;
					return;
				}
			}
			else
			{
				this.visible = true;
				sleepStartTime = 0;
			}
				
			if (this.visible)
				super.tickHandler(event);
		}
	}
}