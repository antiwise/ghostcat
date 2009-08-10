package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.ghostcat.filter.TrapeziumFilterProxy;
	
	[SWF(width="150",height="150")]
	public class TrapeziumExample extends Sprite
	{
		public var p:Sprite;
		public var f:TrapeziumFilterProxy;
		public function TrapeziumExample()
		{
			p = new TestRepeater();
			addChild(p);
			
			f = new TrapeziumFilterProxy(TrapeziumFilterProxy.H);
			f.applyFilter(p);
		
			addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		
		private function enterFrameHandler(event:Event):void
		{
			f.rotation++;
		}
	}
}