package org.ghostcat.skin.code
{
	import flash.display.Sprite;
	
	import org.ghostcat.parse.DisplayParse;
	import org.ghostcat.parse.display.Grid9Parse;
	import org.ghostcat.parse.graphics.GraphicsFill;
	import org.ghostcat.parse.graphics.GraphicsLineStyle;
	import org.ghostcat.parse.graphics.GraphicsRect;
	
	public class BoxSkin extends Sprite
	{
		public function BoxSkin(width:Number=100,height:Number=100,radius:Number = 0,borderColor:uint = 0,borderThickness:Number=1,fillColor:uint = 0xFFFFFF)
		{
			DisplayParse.create([new GraphicsLineStyle(borderThickness,borderColor),
								new GraphicsFill(fillColor),
								new GraphicsRect(0,0,width,height,radius,radius,radius,radius),
								new Grid9Parse(radius,radius,width-radius*2,height-radius*2)]).parse(this);
		}
	}
}