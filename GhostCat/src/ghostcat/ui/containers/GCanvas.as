package ghostcat.ui.containers
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import ghostcat.display.GNoScale;
	import ghostcat.ui.layout.AbsoluteLayout;
	import ghostcat.ui.layout.Layout;
	
	public class GCanvas extends GView
	{
		public var layout:AbsoluteLayout;
		
		public function GCanvas(skin:* = null, replace:Boolean=true)
		{
			super(skin, replace);
			
			layout = new AbsoluteLayout(contentPane);
		}
		
		public function setMetrics(obj:DisplayObject,left:Number=NaN,top:Number=NaN,right:Number=NaN,bottom:Number=NaN):void
		{
			layout.setMetrics(obj,left,top,right,bottom);
		}
		
		public function setCenter(obj:DisplayObject,horizontalCenter:Number=NaN,verticalCenter:Number=NaN):void
		{
			layout.setCenter(obj,horizontalCenter,verticalCenter);
		}
	}
}