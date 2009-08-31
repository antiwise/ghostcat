package org.ghostcat.display
{
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;

	public final class JSBright
	{
		public static function regExternalEventTarget(target:EventDispatcher):void
		{
			if (ExternalInterface.available)
				ExternalInterface.addCallback("dispatchEvent",externalEventHandler)
		}
		
		private static function externalEventHandler(eventString:String):void
		{
			var xml:XML = new XML(eventString);
			xml.localName();
		}
	}
}