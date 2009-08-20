package
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import org.ghostcat.display.graphics.EditableGraphicsSprite;
	import org.ghostcat.parse.graphics.GraphicsLineStyle;
	import org.ghostcat.parse.graphics.GraphicsPath;
	
	[SWF(width="400",height="400")]
	public class EditSpriteExample extends Sprite
	{
		public function EditSpriteExample()
		{
			var path:GraphicsPath = new GraphicsPath([new Point(0,0),[new Point(100,0),new Point(50,50)],new Point(0,100)]);
			var p:EditableGraphicsSprite = new EditableGraphicsSprite([new GraphicsLineStyle(0),path]);
			addChild(p);
		}
		
	}
}