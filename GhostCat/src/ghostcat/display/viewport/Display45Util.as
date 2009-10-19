package ghostcat.display.viewport
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.parse.display.DrawParse;
	import ghostcat.util.display.Geom;

	/**
	 * 45度场景相关
	 * @author flashyiyi
	 * 
	 */
	public final class Display45Util
	{
		/**
		 * 最大横坐标
		 */
		public static var maxi:int = 10000;
		
		private static var _wh:Number;
		private static var _width:Number;
		private static var _height:Number;
		
		/**
		 * 格子长宽比
		 */
		public static function get wh():Number
		{
			return _wh
		}
		
		/**
		 * 格子宽度
		 */
		public static function get width():Number
		{
			return _width;
		}
		
		/**
		 * 格子高度
		 */
		public static function get height():Number
		{
			return _height;
		}
		
		
		/**
		 * 设置单个格子的大小
		 * @param w
		 * @param h
		 * 
		 */
		public static function setContentSize(w:Number,h:Number):void
		{
			_width = w;
			_height = h;
			_wh = w / h;
		}
		/**
		 * 排序函数（根据所在格子判断）
		 * 
		 * @param d1
		 * @param d2
		 * @return 
		 * 
		 */
		public static function SORT_45(v1:*, v2:*):int
		{
			if (!wh)
				throw new Error("请先执行Display45Util.setContentSize方法");
			
			var p1:Point = getItemPointAtPoint(new Point(v1.x,v1.y));
			var p2:Point = getItemPointAtPoint(new Point(v2.x,v2.y));
			
			var d:int = (p1.x + p1.y * maxi) - (p2.x + p2.y * maxi);
			if (d > 0)
				return 1;
			else if (d < 0)
				return -1;
			else
				return (v1.y > v2.y) ? 1 : -1;
		}
		
		/**
		 * 排序函数（根据体积判断）
		 * 
		 * @param d1
		 * @param d2
		 * @return 
		 * 
		 */
		public static function SORT_SIZE_45(v1:DisplayObject, v2:DisplayObject):int
		{
			if (!wh)
				throw new Error("请先执行Display45Util.setContentSize方法");
			
			var p1:Point = trans45To90(new Point(v1.x,v1.y));
			var p2:Point = trans45To90(new Point(v2.x,v2.y));
			var r1:Rectangle = v1.getRect(v1);
			var r2:Rectangle = v2.getRect(v2);
			r1 = new Rectangle(p1.x,p1.y,r1.right,r1.bottom);
			r2 = new Rectangle(p2.x,p2.y,r2.right,r2.bottom);
			var d:int = Geom.getRelativeLocation(r1,r2);
			if (d > 4)
				return 1;
			else if (d < 4)
				return -1;
			else
				return (v1.y > v2.y) ? 1 : -1;
		}
		
		/**
		 * 获得屏幕上点的方块索引坐标 
		 * @param p
		 * @param width
		 * @param height
		 * @return 
		 * 
		 */
		public static function getItemPointAtPoint(p:Point):Point
		{
			p = trans45To90(p);
			return new Point(int(p.x / width), int(p.y / height)); 
		}
		
		/**
		 * 从45度显示坐标换算为90度
		 * @param p
		 * @return 
		 * 
		 */
		public static function trans45To90(p:Point):Point
		{
			return new Point(p.x + p.y * wh,p.y - p.x/wh);
		}
		
		/**
		 * 从90度换算为45度显示坐标
		 * @param p
		 * @return 
		 * 
		 */
		public static function trans90To45(p:Point):Point
		{
			return new Point((p.x - p.y * wh)/2,(p.x / wh + p.y)/2);
		}
		
		/**
		 * 转换图像为45角
		 * @param p
		 * 
		 */
		public static function shapeTo45(p:DisplayObject):void
		{
			var m:Matrix = new Matrix();
			m.b = m.c = -Math.tan(1/3);
			m.rotate(Math.PI/4);
			m.tx = p.x;
			m.ty = p.y;
			p.transform.matrix = m;
		}
		
		/**
		 * 根据skin的大小自动判断占用的格子范围（skin的注册点在底面顶点）
		 * 
		 * @param skin
		 * @return 
		 * 
		 */
		public static function getDefaultTileRect(skin:DisplayObject):Point
		{
			var cRect:Rectangle = skin.getRect(skin);
			return new Point(cRect.right / (width / 2),-cRect.left / (width / 2));
		}
		
		/**
		 * 根据skin的大小判断图形的高度
		 * 
		 * @param skin
		 * @return 
		 * 
		 */
		public static function getTileHeight(skin:DisplayObject):Number
		{
			var rect:Rectangle = skin.getRect(skin);
			return -rect.y;
		}
		
		/**
		 * 45度分割图形
		 * 
		 * @param v
		 * @param asBitmap	是否转化为位图
		 * @return 
		 * 
		 */
		public static function divShape(v:DisplayObject,asBitmap:Boolean):Array
		{
			var cRect:Rectangle = v.getRect(v);
			var w:int = int(cRect.right / (width / 2));
			var h:int = int(-cRect.left / (width / 2));
			var deep:int = int(-cRect.y);
			var startPoint:Point = new Point(-cRect.left,-cRect.top);
			
			if (asBitmap)
			{
				var bitmap:BitmapData = new DrawParse(v).createBitmapData();
				return divBitmapData(bitmap,w,h,deep,startPoint);
			}
			else
			{
				var result:Array = [];
				
				for (var j:int = 0;j < h;j++)
				{
					result.push([]);
					for (var i:int = 0;i < w;i++)
					{
						var p:Point = new Point(startPoint.x + (i - j) * width / 2,startPoint.y + (i + j) * height / 2);
						result[j].push(getDivShape(v,p,deep))
					}
				}
				return result;
			}
		}
		
		/**
		 * 按45度分割图片
		 * 
		 * @param bitmap	位图
		 * @param w	占用格子宽度
		 * @param h	占用格子高度
		 * @param deep	物品高度
		 * @param startPoint	物品底部区域最上的顶点
		 * @return 
		 * 
		 */
		public static function divBitmapData(bitmap:BitmapData,w:int,h:int,deep:int,startPoint:Point):Array
		{
			var result:Array = [];
			
			for (var j:int = 0;j < h;j++)
			{
				result.push([]);
				for (var i:int = 0;i < w;i++)
				{
					var p:Point = new Point(startPoint.x + (i - j) * width / 2,startPoint.y + (i + j) * height / 2);
					result[j].push(getDivBitmapData(bitmap,p,deep))
				}
			}
			bitmap.dispose();
			return result;
		}
		
		private static function getDivBitmapData(v:BitmapData,p:Point,deep:int):BitmapData
		{
			var bitmap:BitmapData = new BitmapData(width,height,true,0);
			for (var j:int = -deep;j < height;j++)
			{
				for (var i:int = 0;i < width;i++)
				{
					var dx:Number = Math.abs(width / 2 - i);
					var dy:Number = (j < height / 2) ? (height / 2 - j) : (j - (height / 2 + deep));
					if (dx / (width / 2) + dy / (height / 2) <= 1)
						bitmap.setPixel32(i,j,v.getPixel32(i + p.x,j + p.y))
				}
			}
			return bitmap;
		}
		
		private static function getDivShape(v:DisplayObject,p:Point,deep:int):Sprite
		{
			var container:Sprite = new Sprite();
			var shape:DisplayObject = v["constructor"]() as DisplayObject;
			shape.x = -p.x;
			shape.y = -p.y;
			container.addChild(shape);
			var mask:Shape = new Shape();
			mask.graphics.beginFill(0);
			mask.graphics.moveTo(0,0);
			mask.graphics.lineTo(width / 2,height / 2);
			if (deep)
				mask.graphics.lineTo(width / 2,height / 2 + deep);
			mask.graphics.lineTo(0,height + deep);
			mask.graphics.lineTo(-width / 2,height / 2 + deep);
			if (deep)
				mask.graphics.lineTo(-width / 2,height / 2);
			mask.graphics.endFill();
			container.addChild(mask);
			shape.mask = mask;
			return container;
		}
	}
}