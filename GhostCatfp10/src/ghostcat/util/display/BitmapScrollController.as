package ghostcat.util.display
{
	import flash.display.BitmapData;

	/**
	 * 设置x,y轴自动对位图调用scroll来滚屏
	 * @author flashyiyi
	 * 
	 */
	public class BitmapScrollController
	{
		public var bitmapData:BitmapData
		private var _x:Number;

		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
			var offest:int = Math.round(_x) - scrollX;
			if (offest != 0)
			{
				scrollX = Math.round(_x);
				bitmapData.scroll(-offest,0);
			}
		}

		private var _y:Number;

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
			var offest:int = Math.round(_y) - scrollY;
			if (offest != 0)
			{
				scrollY = Math.round(_y);
				bitmapData.scroll(0,-offest);
			}
		}

		private var scrollX:int;
		private var scrollY:int;
		public function BitmapScrollController(bmd:BitmapData,x:Number = 0.0,y:Number = 0.0)
		{
			this.bitmapData = bmd;
			this.setPosition(x,y);
		}
		
		public function setPosition(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
			this.scrollX = Math.round(x);
			this.scrollY = Math.round(y);
		}		
	}
}