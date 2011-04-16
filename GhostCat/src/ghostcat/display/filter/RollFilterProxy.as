package ghostcat.display.filter
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Point;
	
	import ghostcat.events.TickEvent;
	import ghostcat.util.Tick;
	
	/**
	 * 循环滚动滤镜，可以用来做滚动背景或者滚动文本
	 * 必须用applyFilter方法来给对象应用滤镜
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class RollFilterProxy extends FilterProxy
	{
		public var mask:BitmapData;
		
		/**
		 * 每秒移动的像素
		 */
		public var speed:Point = new Point();
		
		/**
		 * 当前位置
		 */
		public var pos:Point = new Point();
		
		public function RollFilterProxy()
		{
			super(new DisplacementMapFilter());
			Tick.instance.addEventListener(TickEvent.TICK,tickHandler,false,0,true);
		}
		
		public function update():void
		{
			if (!mask)
				updateMask();
				
			changeFilter(createFilter(mask,pos));
		}
		
		public function updateMask():void
		{
			if (mask)
				mask.dispose();
			
			if (!owner)
				return;
				
			mask = new BitmapData(Math.ceil(owner.width),Math.ceil(owner.height));
		}
		
		
		public static function createFilter(bitmapData:BitmapData, pos:Point):DisplacementMapFilter
		{
			return new DisplacementMapFilter(bitmapData,new Point(),BitmapDataChannel.RED,BitmapDataChannel.GREEN,pos.x,pos.y)
		}
		
		private function tickHandler(event:TickEvent):void
		{
			var offest:Number = event.interval / 1000;
			pos = pos.add(new Point(speed.x * offest,speed.y * offest));
			
			update();
		}
		
		public override function removeFilter():void
		{
			super.removeFilter();
			Tick.instance.removeEventListener(TickEvent.TICK,tickHandler);
		}
	}
}