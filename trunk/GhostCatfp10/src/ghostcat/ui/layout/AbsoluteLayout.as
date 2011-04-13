package ghostcat.ui.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;

	/**
	 * 绝对布局
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class AbsoluteLayout extends PaddingLayout
	{
		private var layoutDict:Dictionary = new Dictionary(true);
		
		/**
		 * 设置外围方框的距离 
		 * @param obj
		 * @param left
		 * @param top
		 * @param right
		 * @param bottom
		 * 
		 */
		public function setMetrics(obj:DisplayObject,left:Number=NaN,top:Number=NaN,right:Number=NaN,bottom:Number=NaN):void
		{
			layoutDict[obj] = new MetricsItem(left,top,right,bottom);
			invalidateLayout();
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
			layoutDict[obj] = new CenterItem(horizontalCenter,verticalCenter);
			invalidateLayout();
		}
		
		public function AbsoluteLayout(target:DisplayObjectContainer=null,isRoot:Boolean = false)
		{
			super(target,isRoot);
		}
		/** @inheritDoc*/
		protected override function layoutChildren(x:Number, y:Number, w:Number, h:Number) : void
		{
			for (var obj:* in layoutDict)
			{
				var item:* = layoutDict[obj]
				if (item is MetricsItem)
				{
					var item1:MetricsItem = layoutDict[obj] as MetricsItem;
					LayoutUtil.metrics(obj,target,item1.left + paddingLeft,item1.top + paddingTop,item1.right + paddingRight,item1.bottom + paddingBottom);
				}
				else if (item is CenterItem)
				{
					var item2:CenterItem = item as CenterItem;
					LayoutUtil.center(obj,target,item2.horizontalCenter,item2.verticalCenter);
				}
			}
		}
	}
}

class MetricsItem
{
	public var left:Number;
	public var right:Number;
	public var top:Number;
	public var bottom:Number;
	public function MetricsItem(left:Number=NaN,top:Number=NaN,right:Number=NaN,bottom:Number=NaN)
	{
		this.left = left;
		this.right= right;
		this.top = top;
		this.bottom = bottom;
	}
}

class CenterItem
{
	public var horizontalCenter:Number;
	public var verticalCenter:Number;
	public function CenterItem(horizontalCenter:Number=NaN,verticalCenter:Number=NaN)
	{
		this.horizontalCenter = horizontalCenter;
		this.verticalCenter = verticalCenter;
	}
}