package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.display.filter.DisplacementMapFilterProxy;
	import ghostcat.display.filter.WaveFilterProxy;
	
	[SWF(width="1000",height="1000")]
	public class WaveExample extends Sprite
	{
		[Embed(source="p1.jpg")]
		public var cls:Class;

		private var f:WaveFilterProxy;
		public function WaveExample()
		{
			addChild(new cls());
			
			f = new WaveFilterProxy(0);
			f.applyFilter(this);
			
			addEventListener(Event.ENTER_FRAME,tickHandler);
		}
		
		protected function tickHandler(event:Event):void
		{
			f.rect = new Rectangle(mouseX - 200,mouseY - 100,400,200);
			f.cycleStart = f.cycleStart + 0.05 - int(f.cycleStart + 0.05);
		}
		
	}
}