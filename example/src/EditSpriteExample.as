package
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import ghostcat.display.graphics.EditableGraphicsSprite;
	import ghostcat.parse.graphics.GraphicsLineStyle;
	import ghostcat.parse.graphics.GraphicsPath;
	import ghostcat.ui.CursorSprite;
	import ghostcat.util.Asyn;
	
	[SWF(width="400",height="400")]
	/**
	 * 编辑矢量图形例子
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class EditSpriteExample extends Sprite
	{
		public function EditSpriteExample()
		{
			var path:GraphicsPath = new GraphicsPath([new Point(0,0),[new Point(100,0),new Point(50,50)],new Point(0,100)]);
			var p:EditableGraphicsSprite = new EditableGraphicsSprite([new GraphicsLineStyle(0),path]);
			addChild(p);
			
			addChild(new CursorSprite())
		}
		
	}
}