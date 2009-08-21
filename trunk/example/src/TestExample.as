package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.ghostcat.display.graphics.LinkLine;
	
	[SWF(width="400",height="400")]
	public class TestExample extends Sprite
	{
		public function TestExample()
		{
			var p:LinkLine = new LinkLine();
			addChild(p);
			
			p.start = new Point(50,50);
			p.startContent = this;
			
			var p2:Sprite = new Sprite();
			addChild(p2);
			
			p.end = new Point(5,0);
			p.startContent = p2;
			
			var a:Sprite = new t();
			addChild(a);
			removeChild(a);
		}
		
		public function h(event:Event):void
		{
			
		}
	}
}
import flash.display.Sprite;
import flash.events.Event;

class t extends Sprite
{
	public function t():void
	{
		addEventListener(Event.ADDED_TO_STAGE,init);
	}
	private function init(event:Event):void
	{
		parent.addEventListener(Event.ENTER_FRAME,(parent as TestExample).h);
	}
	public function h(event:Event):void
	{
		
	}
	
}