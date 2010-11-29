package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ghostcat.display.transfer.BookTransfer;
	import ghostcat.events.MovieEvent;
	
	[SWF(width="1000",height="800")]
	public class BookTransferExample extends Sprite
	{
		[Embed(source="p6.jpg")]
		public var cls:Class;
		public var t:BookTransfer;
		public function BookTransferExample()
		{
			t = new BookTransfer(new cls());
			t.filp(true,true);
			t.x += 200;
			addChild(t);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
		}
		
		private function mouseMoveHandler(event:MouseEvent):void
		{
			t.point = new Point(t.mouseX,t.mouseY);
		}
	}
}