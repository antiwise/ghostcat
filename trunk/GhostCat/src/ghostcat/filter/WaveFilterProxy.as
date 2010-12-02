package ghostcat.filter
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.filters.BitmapFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Point;
	
	import ghostcat.events.TickEvent;
	import ghostcat.util.Tick;
	
	public class WaveFilterProxy extends FilterProxy
	{
		public var mask:BitmapData;
		public var offest:int;
		
		public function WaveFilterProxy(filter:BitmapFilter=null)
		{
			super(new DisplacementMapFilter());
			Tick.instance.addEventListener(TickEvent.TICK,tickHandler,false,0,true);
		}
		
		public function update():void
		{
			if (!mask)
				updateMask();
			
			changeFilter(createFilter(mask));
		}
		
		public function updateMask():void
		{
			if (mask)
				mask.dispose();
			
			if (!owner)
				return;
			
			mask = new BitmapData(Math.ceil(owner.width),Math.ceil(owner.height));
		}
		
		
		public static function createFilter(bitmapData:BitmapData):DisplacementMapFilter
		{
			return new DisplacementMapFilter(bitmapData,new Point(),BitmapDataChannel.RED,BitmapDataChannel.GREEN)
		}
		
		
		private function tickHandler(event:TickEvent):void
		{
			offest++;
			update();
		}
		
		public override function removeFilter():void
		{
			super.removeFilter();
			Tick.instance.removeEventListener(TickEvent.TICK,tickHandler);
		}
	}
}