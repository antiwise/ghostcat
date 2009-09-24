package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import ghostcat.filter.TrapeziumFilterProxy;
	import ghostcat.util.Geom;
	
	[SWF(width="300",height="300")]
	
	public class TrapeziumExample extends Sprite
	{
		public var p:Sprite;
		public var f:TrapeziumFilterProxy;
		public function TrapeziumExample()
		{
			p = new TestRepeater();
			addChild(p);
			Geom.centerIn(p,stage);
			
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