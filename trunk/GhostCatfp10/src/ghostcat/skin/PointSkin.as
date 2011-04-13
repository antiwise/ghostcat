package ghostcat.skin
{
	import flash.display.Sprite;
	
	import ghostcat.parse.DisplayParse;
	import ghostcat.parse.graphics.GraphicsEllipse;
	import ghostcat.parse.graphics.GraphicsFill;
	import ghostcat.parse.graphics.GraphicsLineStyle;

	/**
	 * 圆点
	 * @author flashyiyi
	 * 
	 */
	public class PointSkin extends Sprite
	{
		public function PointSkin(radius:Number = 3,borderColor:uint = 0,borderThickness:Number=0,fillColor:uint = 0xFFFFFF)
		{
			DisplayParse.create([new GraphicsLineStyle(borderThickness,borderColor),
								new GraphicsFill(fillColor,0.5),
								new GraphicsEllipse(0,0,radius + radius,radius + radius)]).parse(this);
		}
	}
}