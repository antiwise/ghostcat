package ghostcat.util.collision
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 缓存位图边缘进行碰撞检测
	 * 
	 * 这种做法在直角重叠的时候最快，在斜角重叠时最慢。图形的凹边越多则越慢，凸边无影响。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class BitmapCollision extends EventDispatcher
	{
		public var x:int = 0;
		public var y:int = 0;
		public var width:int;
		public var height:int;
		
		/**
		 * 横坐标缓存 
		 */
		public var hP:Array;
		
		/**
		 * 纵坐标缓存
		 */
		public var vP:Array;
		
		/**
		 * 透明颜色
		 */
		public var transparenceColor:uint;
		public function BitmapCollision(bmd:BitmapData,transparenceColor:uint = 0)
		{
			this.transparenceColor = transparenceColor;
			if (bmd)
				createFromBitmapData(bmd);
		}
		
		public function createFromBitmapData(bmd:BitmapData):void
		{
			var i:int;
			var j:int;
			var start:int;
			var p:Array;
			
			this.width = bmd.width;
			this.height = bmd.height;
			
			hP = new Array(height);
			
			for (j = 0;j < height;j++)
			{
				i = 0;
				p = [];
				while (i < width)
				{
					while (bmd.getPixel32(i,j) == transparenceColor && i < width)
						i++;
					if (i == width)
						break;
					p[p.length] = i;
					while (bmd.getPixel32(i,j) != transparenceColor && i < width)
						i++;
					p[p.length] = i;
				}
				hP[j] = p;
			}
			
			vP = new Array(width);
			
			for (j = 0;j < width;j++)
			{
				i = 0;
				p = [];
				while (i < height)
				{
					while (bmd.getPixel32(j,i) == transparenceColor && i < height)
						i++;
					if (i == height)
						break;
					p[p.length] = i;
					while (bmd.getPixel32(j,i) != transparenceColor && i < height)
						i++;
					p[p.length] = i;
				}
				vP[j] = p;
			}
		}
		
		/**
		 * 和一个点检测碰撞 
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */
		public function hitTestPoint(x:int,y:int):Boolean
		{
			var dx:int = x - this.x;
			var dy:int = y - this.y;
			if (dx < 0 || dx >= width || dy < 0 || dy >= height)
				return false;
			
			var ps:Array = hP[y];
			var l:int = ps.length;
			for (var i:int = 0;i < l; i += 2)
			{
				if (ps[i] < x && x < ps[i + 1])
					return true;
			}
			return false;
		}
		
		/**
		 * 两个道具间碰撞 
		 * @param obj
		 * @return 
		 * 
		 */
		public function hitTestObject(obj:BitmapCollision):Boolean
		{
			var i:int;
			var j:int;
			var a:Array;
			var b:Array;
			var dx:int = obj.x - x;
			var dy:int = obj.y - y;
			var k:int;
			var k2:int;
			var startX:int;
			var startY:int;
			var endX:int;
			var endY:int;
			var a1:int;
			var a2:int;
			var b1:int;
			var b2:int;
			
			var intersetRect:Rectangle = new Rectangle(0,0,this.width,this.height).intersection(new Rectangle(dx,dy,obj.width,obj.height));
			if (intersetRect.isEmpty())
				return false;
			
			startX = intersetRect.x;
			startY = intersetRect.y;
			endX = intersetRect.x + intersetRect.width;
			endY = intersetRect.y + intersetRect.height;
			
			if (intersetRect.width > intersetRect.height)
			{
				for (k = startY;k < endY; k++)
				{
					a = hP[k];
					k2 = k - dy;
					if (k2 >= 0 && k2 < obj.height)
					{
						b = obj.hP[k2];
						for (i = 0;i < a.length;i += 2)
						{
							a1 = a[i];
							a2 = a[i + 1];
							if (a1 >= startX || a2 < endX)
							{
								for (j = 0;j < b.length;j += 2)
								{
									if (!(a2 < b[j] + dx || b[j + 1] + dx < a1))
										return true;
								}
							}
						}
					}
				}
			}
			else
			{
				for (k = startX;k < endX; k++)
				{
					a = vP[k];
					k2 = k - dx;
					if (k2 >= 0 && k2 < obj.width)
					{
						b = obj.vP[k2];
						for (i = 0;i < a.length;i += 2)
						{
							a1 = a[i];
							a2 = a[i + 1];
							if (a1 >= startY || a2 < endY)
							{
								for (j = 0;j < b.length;j += 2)
								{
									if (!(a2 < b[j] + dy || b[j + 1] + dy < a1))
										return true;
								}
							}
						}
					}
				}
			}
			return false;
		}
	}
}