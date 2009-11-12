package ghostcat.parse.display
{
	import ghostcat.parse.graphics.GraphicsEllipse;
	import ghostcat.parse.graphics.GraphicsFill;
	
	/**
	 * 书写简单的Rect 
	 * @author flashyiyi
	 * 
	 */
	public class SimpleEllipseParse extends RectParse
	{
		public function SimpleEllipseParse(width:Number,height:Number,color:Number = 0x0,fill:Number = 0xFFFFFF)
		{
			super(
				new GraphicsEllipse(0,0,width,height),
				isNaN(color) ? null : new GraphicsLineStyle(0,color),
				isNaN(fill) ? null : new GraphicsFill(fill)
			);
		}
	}
}