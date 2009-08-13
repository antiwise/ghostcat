package
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.net.URLVariables;
	
	import org.ghostcat.display.viewport.Wall;
	import org.ghostcat.manager.BrowerManager;
	
	[SWF(width="400",height="400")]
	public class TestExample extends Sprite
	{
		public function TestExample()
		{
			var p:Wall = new Wall(new TestRepeater(),new Point(0,100),new Point(50,50),50);
			addChild(p);
		}
		
	}
}