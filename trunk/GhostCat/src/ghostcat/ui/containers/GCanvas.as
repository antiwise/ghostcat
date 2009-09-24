package ghostcat.ui.containers
{
	import flash.display.DisplayObject;
	
	import ghostcat.ui.layout.AbsoluteLayout;
	
	/**
	 * 据对布局容器
	 * @author flashyiyi
	 * 
	 */
	public class GCanvas extends GView
	{
		public function GCanvas(skin:* = null, replace:Boolean=true)
		{
			super(skin, replace);
			
			layout = new AbsoluteLayout(contentPane);
		}
		
		/**
		 * 设置与容器边缘的距离 
		 * @param obj
		 * @param left
		 * @param top
		 * @param right
		 * @param bottom
		 * 
		 */
		public function setMetrics(obj:DisplayObject,left:Number=NaN,top:Number=NaN,right:Number=NaN,bottom:Number=NaN):void
		{
			(layout as AbsoluteLayout).setMetrics(obj,left,top,right,bottom);
		}
		
		/**
		 * 设置与中心的距离
		 * @param obj
		 * @param horizontalCenter
		 * @param verticalCenter
		 * 
		 */
		public function setCenter(obj:DisplayObject,horizontalCenter:Number=NaN,verticalCenter:Number=NaN):void
		{
			(layout as AbsoluteLayout).setCenter(obj,horizontalCenter,verticalCenter);
		}
	}
}