package 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import org.ghostcat.display.viewport.Light;
	import org.ghostcat.display.viewport.Wall;
	
	[SWF(width="500",height="400",backgroundColor="0x0")]
	public class LightExample extends Sprite
	{
		public function LightExample()
		{
			var w:Wall = new Wall(new TestRepeater(),new Point(0,100),new Point(100,0),50);
			addChild(w);
			
			var r:Sprite = new TestRepeater45();
			r.scaleX = r.scaleY = 0.2;
			r.x = 200;
			r.y = 100;
			addChild(r);
			
			var l:Light = new Light(250);
			l.x = 300;
			l.y = 120;
			addChild(l);
			l.addItem(r);
			l.addWall(w);
		}
	}
}