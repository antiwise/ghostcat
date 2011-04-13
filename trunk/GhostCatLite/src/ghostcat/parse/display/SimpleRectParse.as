package ghostcat.parse.display
{
	import ghostcat.parse.graphics.GraphicsFill;
	import ghostcat.parse.graphics.GraphicsLineStyle;
	import ghostcat.parse.graphics.GraphicsRect;
	
	/**
	 * 书写简单的Rect 
	 * @author flashyiyi
	 * 
	 */
	public class SimpleRectParse extends RectParse
	{
		public function SimpleRectParse(width:Number,height:Number,color:Number = 0x0,fill:Number = 0xFFFFFF)
		{
			super(
				new GraphicsRect(0,0,width,height),
				isNaN(color) ? null : new GraphicsLineStyle(0,color),
				isNaN(fill) ? null : new GraphicsFill(fill)
			);
		}
	}
}