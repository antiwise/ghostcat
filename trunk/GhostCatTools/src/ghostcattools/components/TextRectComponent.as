package ghostcattools.components
{
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	import mx.managers.ToolTipManager;
	import mx.utils.GraphicsUtil;
	
	import spark.components.Label;
	import spark.components.TextArea;
	
	public class TextRectComponent extends UIComponent
	{
		public function TextRectComponent(textField)
		{
			super();
		}
		
		public function drawRect(rect:Rectangle):void
		{
			GraphicsUtil.drawRoundRectComplex(this.graphics,rect.x,rect.y,rect.width,rect.height,5,5,5,5);
		}
	}
}