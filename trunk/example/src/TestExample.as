package
{
	import flash.display.Sprite;
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
			
			
			var n:uint = 0xFFFFFF;
			n = n << 8;
			trace(n.toString(16))
		}
		
	}
}