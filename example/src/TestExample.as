package
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import org.ghostcat.display.viewport.Light;
	import org.ghostcat.parse.DisplayParse;
	import org.ghostcat.parse.graphics.GraphicsLineStyle;
	import org.ghostcat.parse.graphics.GraphicsRect;
	import org.ghostcat.util.HitTest;
	
	[SWF(width="400",height="400")]
	public class TestExample extends Sprite
	{
		public var p:Light;
		public function TestExample()
		{
			trace("{0}".replace(new RegExp("\\{0\\}","g"),"123"))
		}
		
	}
}