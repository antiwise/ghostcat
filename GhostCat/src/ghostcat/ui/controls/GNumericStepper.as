package ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	public class GNumericStepper extends GText
	{
		public function GNumericStepper(skin:DisplayObject=null, replace:Boolean=true, enabledAdjustContextSize:Boolean=false, textPos:Point=null)
		{
			super(skin, replace, enabledAdjustContextSize, textPos);
		}
	}
}