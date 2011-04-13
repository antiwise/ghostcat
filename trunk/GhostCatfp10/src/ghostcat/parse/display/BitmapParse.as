package ghostcat.parse.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	import ghostcat.parse.DisplayParse;
	
	/**
	 * 创建位图 
	 * @author flashyiyi
	 * 
	 */
	public class BitmapParse extends DisplayParse
	{
		public var width:int;
		public var height:int;
		public var pos:Point;
		public var transparent:Boolean = true;
		public var fillColor:uint = 0x00FFFFFF;
		public var pixelSnapping:String = "auto";
		public var smoothing:Boolean = false;
		
		public var grid9:Grid9Parse;
		
		public function BitmapParse(width:int,height:int,pos:Point=null,transparent:Boolean = true,fillColor:uint = 0x00FFFFFF,pixelSnapping:String = "auto",smoothing:Boolean = false)
		{
			this.width = width;
			this.height = height;
			this.pos = pos;
			this.transparent = transparent;
			this.fillColor = fillColor;
			
			this.pixelSnapping = pixelSnapping;
			this.smoothing = smoothing;
		}
		/** @inheritDoc*/
		public function createBitmap():Bitmap
		{
			if (!width || !height)
				return new Bitmap(null,pixelSnapping,smoothing);
			
			var bitmapData:BitmapData = new BitmapData(width,height,transparent,fillColor);
			var bitmap:Bitmap = new Bitmap(bitmapData,pixelSnapping,smoothing);
			if (pos)
			{
				bitmap.x = pos.x;
				bitmap.y = pos.y;
			}
			return bitmap;
		}
		/** @inheritDoc*/
		public override function parseContainer(target:DisplayObjectContainer) : void
		{
			super.parseContainer(target);
			target.addChild(createBitmap());
		}
		/** @inheritDoc*/
		public override function parseDisplay(target:DisplayObject) : void
		{
			super.parseDisplay(target);
			
			if (grid9)
				grid9.parse(target);
		}
		
		/**
		 * 创建一个位图
		 * @param width
		 * @param height
		 * @param pos
		 * @param transparent
		 * @param fillColor
		 * @param pixelSnapping
		 * @param smoothing
		 * @return 
		 * 
		 */
		public static function createBitmap(width:int,height:int,pos:Point=null,transparent:Boolean = true,fillColor:uint = 0x00FFFFFF,pixelSnapping:String = "auto",smoothing:Boolean = false):Bitmap
		{
			return new BitmapParse(width,height,pos,transparent,fillColor,pixelSnapping,smoothing).createBitmap();
		}
	}
}