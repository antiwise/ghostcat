package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import org.ghostcat.parse.DisplayParse;
	import org.ghostcat.parse.graphics.GraphicsFill;
	import org.ghostcat.parse.graphics.GraphicsRect;
	
	[SWF(width="400",height="400")]
	public class TestExample extends Sprite
	{
		public var p:Sprite;
		public function TestExample()
		{
			p = DisplayParse.createSprite([new GraphicsFill(0),new GraphicsRect(0,0,100,100)]);
			addChild(p);
			p.x = 50;
			p.y = 150;
			
			var rect:Rectangle = p.getRect(p);
			
			var m:Matrix = p.transform.matrix.clone();
            m.b = Math.tan(1/3);
            m.c = Math.tan(1/3);
            m.rotate(Math.PI/4);
            p.transform.matrix = m;
		}
		
	}
}