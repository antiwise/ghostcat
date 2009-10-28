package ghostcat.display.transfer.effect
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.util.core.Handler;

	/**
	 * 分割效果
	 *  
	 * @author flashyiyi
	 * 
	 */
	public class SegmentHandler extends Handler
	{
		public var type:int;
		public var size:int;
		public function SegmentHandler(type:int = 0,size:int = 20):void
		{
			super();
			this.type = type;
			this.size = size;
		}
		
		public override function call(...params):*
		{
			var normalBitmapData:BitmapData = params[0];
			var bitmapData:BitmapData = params[1];
			var deep:Number = params[2];
			
			bitmapData.fillRect(bitmapData.rect,0);
			if (type == 0)
			{
				var len:int = Math.ceil(bitmapData.height / size);
				for (var i:int = 0;i < len;i++)
				{
					var rect:Rectangle = new Rectangle(0,i * size,bitmapData.width,size)
					if (i % 2 ==0)
						bitmapData.copyPixels(normalBitmapData,rect,new Point(-bitmapData.width * deep,rect.y));
					else
						bitmapData.copyPixels(normalBitmapData,rect,new Point(bitmapData.width * deep,rect.y));
				}
			}
			else
			{
				len = Math.ceil(bitmapData.width / size);
				for (i = 0;i < len;i++)
				{
					rect = new Rectangle(i * size,0,size,bitmapData.height)
					if (i % 2 ==0)
						bitmapData.copyPixels(normalBitmapData,rect,new Point(rect.x,-bitmapData.height * deep));
					else
						bitmapData.copyPixels(normalBitmapData,rect,new Point(rect.x,bitmapData.height * deep));
				}
			}
		}
	}
}