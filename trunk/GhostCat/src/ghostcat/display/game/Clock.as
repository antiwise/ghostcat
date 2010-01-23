package ghostcat.display.game
{
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	
	import ghostcat.display.GBase;
	import ghostcat.util.display.SearchUtil;

	public class Clock extends GBase
	{
		public var hour:DisplayObject;
		public var minute:DisplayObject;
		public var second:DisplayObject;
		public function Clock(skin:* = null, replace:Boolean = true):void
		{
			super(skin,replace);
			
			this.refreshInterval = 1000;
		}
		
		public override function setContent(skin:*, replace:Boolean=true) : void
		{
			super.setContent(skin,replace);
		
			if (this.content)
			{
				this.hour = SearchUtil.findChildByProperty(this.content,"name","hour");
				this.minute = SearchUtil.findChildByProperty(this.content,"name","minute");
				this.second = SearchUtil.findChildByProperty(this.content,"name","second");
			}
			else
			{
				this.hour = null;
				this.minute = null;
				this.second = null;
			}
			
			refreshHandler(null);
		}
		
		protected override function refreshHandler(event:TimerEvent) : void
		{
			var t:Date = getDate();
			var s:int = t.seconds
			var m:int = t.minutes;
			var h:int = t.hours;
			
			if (this.hour)
				this.hour.rotation = h / 12 * 360;
			
			if (this.minute)
				this.minute.rotation = m / 60 * 360;
			
			if (this.second)
				this.second.rotation = s / 60 * 360;
		}
		
		protected function getDate():Date
		{
			return new Date();
		}
	}
}