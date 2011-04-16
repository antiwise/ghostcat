package ghostcat.display.bitmap
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	
	import ghostcat.display.GBase;
	import ghostcat.display.GNoScale;
	import ghostcat.events.TickEvent;

	/**
	 * 将一个图形即时显示在位图上，并可进行中心缩放。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class BitmapDrawScreen extends GNoScale
	{
		/**
		 * 源
		 */
		public var source:DisplayObject;
		
		private var _accuracy:Number = 1.0;
		private var _zoom:Number = 1.0;
		
		/**
		 * 绘制的精度，提高此值可在缩放时消除马赛克
		 */
		public function get accuracy():Number
		{
			return _accuracy;
		}

		public function set accuracy(value:Number):void
		{
			_accuracy = value;
			if (content is Bitmap)
				(content as Bitmap).bitmapData.dispose();
			
			setContent(new Bitmap(new BitmapData(width * value,height * value,false)))
			zoom = zoom;
		}

		/**
		 * 缩放比
		 */
		public function get zoom():Number
		{
			return _zoom;
		}

		public function set zoom(value:Number):void
		{
			_zoom = value;
			
			content.scaleX = content.scaleY = value / accuracy;
			content.x = - width / accuracy * (value - 1) / 2;
			content.y = - height / accuracy * (value - 1) / 2;
		}

		
		public function BitmapDrawScreen(source:DisplayObject,width:int, height:int, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super();
			
			this.width = width;
			this.height = height;
			
			this.source = source;
			this.enabledTick = true;
			
			accuracy = accuracy;
		}
		/** @inheritDoc*/
		protected override function tickHandler(event:TickEvent) : void
		{
			var bitmapData:BitmapData = (content as Bitmap).bitmapData;
			bitmapData.fillRect(bitmapData.rect,0xFFFFFF);
			var m:Matrix = new Matrix();
			m.scale(accuracy,accuracy);
			bitmapData.draw(source,m);
			super.tickHandler(event);
		}
	}
}