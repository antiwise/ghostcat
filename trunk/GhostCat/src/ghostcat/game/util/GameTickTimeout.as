package ghostcat.game.util
{
	import flash.utils.Dictionary;
	
	import ghostcat.events.TickEvent;
	import ghostcat.game.util.GameTick;

	public final class GameTickTimeout
	{
		private static var timeoutInt:int = 1;
		private static var timeoutDict:Dictionary = new Dictionary();
		public static function setTimeout(closeure:Function,delay:int,...reg):int
		{
			var i:int = timeoutInt++;
			GameTick.instance.addEventListener(TickEvent.TICK,tickHandler,false,0,false);
			timeoutDict[i] = tickHandler;
			return i;
			
			function tickHandler(e:TickEvent):void
			{
				delay -= e.interval;
				if (delay <= 0)
				{
					clearTimeout(i);
					closeure.apply(null,reg);
				}
			}
		}
		
		public static function clearTimeout(i:int):void
		{
			var h:Function = timeoutDict[i];
			if (h != null)
			{
				GameTick.instance.removeEventListener(TickEvent.TICK,h);
				delete timeoutDict[i];
			}
		}
		
		public static function getTimeoutId(h:Function):int
		{
			for (var p:* in timeoutDict)
			{
				if (timeoutDict[p] == h)
					return p;
			}
			return -1;
		}
		
		public static function clearTimeoutHandler(h:Function):void
		{
			clearTimeout(getTimeoutId(h));
		}
		
		public static function clearAllTimeout():void
		{
			for each (var h:Function in timeoutDict)
				GameTick.instance.removeEventListener(TickEvent.TICK,h);
			
			timeoutDict = new Dictionary();
		}
	}
}