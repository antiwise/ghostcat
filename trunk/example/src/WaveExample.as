package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ghostcat.display.filter.DisplacementMapFilterProxy;
	
	[SWF(width="1000",height="1000")]
	public class WaveExample extends Sprite
	{
		[Embed(source="p1.jpg")]
		public var cls:Class;

		private var f:DisplacementMapFilterProxy;
		public function WaveExample()
		{
			addChild(new cls());
			
			f = new DisplacementMapFilterProxy(DisplacementMapFilterProxy.BUBBLE);
			f.pos = new Point(100,100);
			f.applyFilter(this);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler)
		}
		
		protected function mouseMoveHandler(event:MouseEvent):void
		{
			f.pos = new Point(mouseX - 128,mouseY - 128);
		}
		
	}
}