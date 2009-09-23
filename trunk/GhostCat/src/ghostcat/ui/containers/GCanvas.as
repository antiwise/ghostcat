package ghostcat.ui.containers
{
	import flash.display.DisplayObject;
	
	import ghostcat.ui.layout.AbsoluteLayout;
	
	public class GCanvas extends GView
	{
		public function GCanvas(skin:* = null, replace:Boolean=true)
		{
			super(skin, replace);
			
			layout = new AbsoluteLayout(contentPane);
		}
		
		public function setMetrics(obj:DisplayObject,left:Number=NaN,top:Number=NaN,right:Number=NaN,bottom:Number=NaN):void
		{
			(layout as AbsoluteLayout).setMetrics(obj,left,top,right,bottom);
		}
		
		public function setCenter(obj:DisplayObject,horizontalCenter:Number=NaN,verticalCenter:Number=NaN):void
		{
			(layout as AbsoluteLayout).setCenter(obj,horizontalCenter,verticalCenter);
		}
	}
}