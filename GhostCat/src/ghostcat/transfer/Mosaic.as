package ghostcat.transfer
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	public class Mosaic extends GBitmapTransfer
	{
		public var normalBitmapData:BitmapData;
		
		private var _mosaicSize:int = 0;
		
		public function Mosaic(target:DisplayObject=null)
		{
			super(target);
		}
		
		public function get mosaicSize():int
		{
			return _mosaicSize;
		}

		public function set mosaicSize(v:int):void
		{
			if (_mosaicSize == v)
				return;
			
			_mosaicSize = v;
			renderMosaic();
		}

		protected override function render():void
		{
			super.render();
			
			if (normalBitmapData)
				normalBitmapData.dispose();
			
			normalBitmapData = bitmapData.clone();
			
			renderMosaic();
		}
		
		protected function renderMosaic():void
		{
			if (normalBitmapData)
				mosaic(normalBitmapData,bitmapData,mosaicSize,mosaicSize);
		}
		
		public override function destory() : void
		{
			super.destory();
			
			if (normalBitmapData)
				normalBitmapData.dispose();
		}
		
		/**
		 * 马赛克
		 * 
		 * @param source
		 * @param result
		 * @param scaleX
		 * @param scaleY
		 * @return 
		 * 
		 */
		public static function mosaic(source:BitmapData,result:BitmapData=null,width:int = 1.0,height:int = 1.0):BitmapData
		{
			if (!result)
				result = source.clone();
				
			var wl:int = Math.ceil(source.width / width);
			var hl:int = Math.ceil(source.height / height);
			
			for (var j:int = 0;j < hl;j++)
			{
				for (var i:int = 0;i < wl;i++)
				{
					var rect:Rectangle = new Rectangle(i*width,j*height,width,height);
					result.fillRect(rect,getAvgColor(source,rect));
				}
			}
			return result;
		}
		
		/**
		 * 获得位图的平均颜色
		 * 
		 * @param source
		 * @param rect
		 * @return 
		 * 
		 */
		public static function getAvgColor(source:BitmapData,rect:Rectangle=null):uint
		{
			if (!rect)
				rect = new Rectangle(0,0,source.width,source.height);
			
			var a:Number = 0;
			var ar:Number = 0;
			var ag:Number = 0;
			var ab:Number = 0;
			for (var j:int = rect.top;j < rect.bottom;j++)
			{
				for (var i:int = rect.left;i < rect.right;i++)
				{
					var rgb:uint = source.getPixel32(i,j);
					a += (rgb >> 24) & 0xFF
					ar += (rgb >> 16) & 0xFF;
					ag += (rgb >> 8) & 0xFF;
					ab += rgb & 0xFF;
				}
			}
			var p:Number = rect.width * rect.height;
			return (int(a/p) << 24) | (int(ar/p) << 16) | (int(ag/p) << 8) | int(ab/p);
		}
	}
}