package ghostcat.game.util
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.parse.display.DrawParse;

	/**
	 * 程序分离45度角显示的素材
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class Separate45Util
	{
		/**
		 * 45度分割图形
		 * 
		 * @param v
		 * @param asBitmap	是否转化为位图
		 * @param width	格子宽度
		 * @param height	格子高度
		 * @return 
		 * 
		 */
		public static function divShape(v:DisplayObject,asBitmap:Boolean,width:Number,height:Number):Array
		{
			var cRect:Rectangle = v.getRect(v);
			var w:int = int(cRect.right / (width / 2));
			var h:int = int(-cRect.left / (width / 2));
			var deep:int = int(-cRect.y);
			var startPoint:Point = new Point(-cRect.left,-cRect.top);
			
			if (asBitmap)
			{
				var bitmap:BitmapData = new DrawParse(v).createBitmapData();
				return divBitmapData(bitmap,w,h,deep,startPoint,width,height);
			}
			else
			{
				var result:Array = [];
				
				for (var j:int = 0;j < h;j++)
				{
					result.push([]);
					for (var i:int = 0;i < w;i++)
					{
						var p:Point = new Point((i - j) * width / 2,(i + j) * height / 2);
						result[j].push(getDivShape(v,p,deep,width,height))
					}
				}
				return result;
			}
		}
		
		/**
		 * 按45度分割图片
		 * 
		 * @param bitmap	位图
		 * @param w	占用格子个数宽度
		 * @param h	占用格子个数高度
		 * @param deep	物品高度
		 * @param startPoint	物品底部区域最上的顶点
		 * @param width	格子宽度
		 * @param height	格子高度
		 * @return 
		 * 
		 */
		public static function divBitmapData(bitmap:BitmapData,w:int,h:int,deep:int,startPoint:Point,width:Number,height:Number):Array
		{
			var result:Array = [];
			
			for (var j:int = 0;j < h;j++)
			{
				result.push([]);
				for (var i:int = 0;i < w;i++)
				{
					var p:Point = new Point(startPoint.x + (i - j) * width / 2,startPoint.y + (i + j) * height / 2);
					result[j].push(getDivBitmapData(bitmap,p,deep,width,height))
				}
			}
			bitmap.dispose();
			return result;
		}
		
		/**
		 * 获得一个分离的位图 
		 * 
		 * @param v	位图源
		 * @param p	取样注册点起点
		 * @param deep	高度
		 * @param width	格子宽度
		 * @param height	格子高度
		 * @return 
		 * 
		 */
		private static function getDivBitmapData(v:BitmapData,p:Point,deep:int,width:Number,height:Number):BitmapData
		{
			var bitmap:BitmapData = new BitmapData(width,height + deep,true,0);
			for (var j:int = 0;j < height + deep;j++)
			{
				for (var i:int = 0;i < width;i++)
				{
					var dx:Number = Math.abs(width / 2 - i);
					var dy:Number = (j < height / 2) ? (height / 2 - j) : (j - (height / 2 + deep));
					if (dx / (width / 2) + dy / (height / 2) <= 1)
						bitmap.setPixel32(i,j,v.getPixel32(i + p.x - width/2,j + p.y - deep))
				}
			}
			return bitmap;
		}
		
		/**
		 * 获得一个分离的图形
		 * 
		 * @param v	图形源
		 * @param p	取样注册点起点
		 * @param deep	高度
		 * @param width	格子宽度
		 * @param height	格子高度
		 * @return 
		 * 
		 */
		private static function getDivShape(v:DisplayObject,p:Point,deep:int,width:Number,height:Number):Sprite
		{
			var container:Sprite = new Sprite();
			var shape:DisplayObject = new v["constructor"]() as DisplayObject;
			shape.x = -p.x;
			shape.y = -p.y;
			container.addChild(shape);
			var mask:Shape = new Shape();
			mask.graphics.beginFill(0);
			mask.graphics.moveTo(0,-deep);
			mask.graphics.lineTo(width / 2,height / 2 - deep);
			if (deep)
				mask.graphics.lineTo(width / 2,height / 2);
			mask.graphics.lineTo(0,height);
			mask.graphics.lineTo(-width / 2,height / 2);
			if (deep)
				mask.graphics.lineTo(-width / 2,height / 2 - deep);
			mask.graphics.endFill();
			container.addChild(mask);
			shape.mask = mask;
			return container;
		}
	}
}