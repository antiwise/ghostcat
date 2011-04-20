package ghostcat.util.collision
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.util.display.BitmapUtil;
	
	/**
	 * 缓存位图边缘进行碰撞检测
	 * @author flashyiyi
	 * 
	 */
	public class BitmapCollision extends EventDispatcher
	{
		public var target:DisplayObject;
		public var bitmapData:BitmapData;
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
		
		public var offestX:Number = 0.0;
		public var offestY:Number = 0.0;
		
		public function get x():Number
		{
			return target.x + offestX;
		}
		
		public function get y():Number
		{
			return target.y + offestY;
		}
		
		public function BitmapCollision(target:DisplayObject)
		{
			this.target = target;
			if (target)
				createFromTarget(target);
		}
		
		public function createFromTarget(target:DisplayObject):void
		{
			if (this.bitmapData)
				this.bitmapData.dispose();
			
			if (target is Bitmap)
			{
				this.bitmapData = (target as Bitmap).bitmapData;
				this.offestX = this.offestY = 0.0;
			}
			else
			{
				var rect:Rectangle = target.getBounds(target);
				var m:Matrix = new Matrix();
				m.translate(-rect.x,-rect.y);
				bitmapData = new BitmapData(Math.ceil(rect.width),Math.ceil(rect.height),true,0);
				bitmapData.draw(target,m);
				
				this.offestX = rect.x;
				this.offestY = rect.y;
			}
			createFromBitmapData(bitmapData);
		}
		
		private function createFromBitmapData(bmd:BitmapData):void
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
					while (bmd.getPixel32(i,j) == 0 && i < width)
						i++;
					if (i == width)
						break;
					p[p.length] = i;
					while (bmd.getPixel32(i,j) != 0 && i < width)
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
					while (bmd.getPixel32(j,i) == 0 && i < height)
						i++;
					if (i == height)
						break;
					p[p.length] = i;
					while (bmd.getPixel32(j,i) != 0 && i < height)
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
			var dx:int = x - this.x + offestX;
			var dy:int = y - this.y + offestY;
			if (dx < 0 || dx >= width || dy < 0 || dy >= height)
				return false;
			
//			var ps:Array = hP[y];
//			var l:int = ps.length;
//			for (var i:int = 0;i < l; i += 2)
//			{
//				if (ps[i] < x && x < ps[i + 1])
//					return true;
//			}
			return this.bitmapData.getPixel32(dx,dy) != 0;
		}
		
		/**
		 * 两个道具间碰撞，不支持旋转
	 	 * 这种做法在直角重叠的时候最快，在斜角重叠时最慢。图形的凹边越多则越慢，凸边无影响。
		 * 
		 * @param obj
		 * @param rough	检测粗略程度，越高效率越高，但可能会漏掉碰撞
		 * @return 
		 * 
		 */
		public function hitTestObject(obj:BitmapCollision,rough:int = 1):Boolean
		{
			var i:int;
			var j:int;
			var a:Array;
			var b:Array;
			var dx:int = obj.x - this.x;
			var dy:int = obj.y - this.y;
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
				for (k = startY;k < endY; k+=rough)
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
				for (k = startX;k < endX; k+=rough)
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
		
		/**
		 * 用边缘上的点来检查另一个图形的像素，可以支持旋转，但是处于包含关系的时候无法检测碰撞
		 * 比上个方法慢很多
		 *  
		 * @param obj
		 * @param rough	检测粗略程度，越高效率越高，但可能会漏掉碰撞
		 * @return 
		 * 
		 */
		public function hitTestObjectRotation(obj:BitmapCollision,rough:int = 1):Boolean
		{
			var i:int;
			var a:Array;
			var dx:int = obj.x - this.x;
			var dy:int = obj.y - this.y;
			var k:int;
			
			if (!this.target.hitTestObject(obj.target))
				return false;
			
			
			for (k = 0;k < this.height; k+=rough)
			{
				a = hP[k];
				for (i = 0;i < a.length;i ++)
				{
					var p:Point = new Point(a[i] - offestX,k - offestY);
					var p2:Point = obj.target.globalToLocal(this.target.localToGlobal(p));
					p2.x += obj.offestX;
					p2.y += obj.offestY;
					if (p2.x >= 0 && p2.y >= 0 && p2.x < obj.width && p2.y < obj.height)
					{
						if (obj.bitmapData.getPixel32(p2.x,p2.y) != 0)
							return true;
					}
				}
			}
			return false;
		}
	}
}