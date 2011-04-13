package ghostcat.util.display
{
	import flash.geom.Point;

	/**
	 * 坐标旋转类 
	 * @author flashyiyi
	 * 
	 */
	public final class RotationUtil
	{
		/**
		 * 旋转点
		 * @param p
		 * @param rotation	角度值
		 * @param regPoint
		 * @return 
		 * 
		 */
		public static function rotationAt(p:Point,rotation:Number = 0, regPoint:Point = null):Point
		{
			if (regPoint)
				regPoint = new Point();
			
			var offest:Point = p.subtract(regPoint);
			var angle:Number = Math.atan2(offest.y,offest.x);
			var len:Number = offest.length;
			offest = Point.polar(len,angle + rotation / 180 * Math.PI);
			return regPoint.add(offest);
		}
		
		/**
		 * 按90的倍数旋转点 
		 * @param p
		 * @param rotation
		 * @param regPoint
		 * @return 
		 * 
		 */
		public static function rotation90At(p:Point,rotation:int = 0, regPoint:Point = null):Point
		{
			if (regPoint)
				regPoint = new Point();
			var offest:Point = p.subtract(regPoint);
			
			rotation = rotation % 4;
			if (rotation < 0)
				rotation += 4;
			
			switch (rotation)
			{
				case 0:
					break;
				case 1:
					offest = new Point(-offest.y,offest.x)
					break;
				case 2:
					offest = new Point(-offest.x,-offest.y);
					break;
				case 3:
					offest = new Point(offest.y,-offest.x);
					break
			}
			
			return regPoint.add(offest);
		}
		
		/**
		 * 旋转数组
		 * @param grid
		 * @param rotation
		 * @param regPoint
		 * @return 
		 * 
		 */
		public static function rotationGrid(grid:Array,rotation:int = 0):Array
		{
			var r:Array = [];
			var w:int = grid[0].length;
			var h:int = grid.length;
			
			rotation = rotation % 4;
			if (rotation < 0)
				rotation += 4;
			
			var len:int =  (rotation % 2 == 0) ? h : w;
			for (var i:int = 0;i < len;i++)
				r[i] = [];
			
			for (var j:int = 0; j < h;j++)
			{
				for (i = 0; i < w;i++)
				{
					switch (rotation)
					{
						case 0:
							r[j][i] = grid[j][i];
							break;
						case 1:
							r[i][h - j - 1] = grid[j][i];
							break;
						case 2:
							r[h - j - 1][w - i - 1] = grid[j][i];
							break;
						case 3:
							r[w - i - 1][j] = grid[j][i];
							break
					}
				}
			}
			return r;
		}
		
		/**
		 * 旋转数组的注册点 
		 * @param grid
		 * @param regPoint
		 * @return 
		 * 
		 */
		public static function rotationGridRegPoint(grid:Array,regPoint:Point,rotation:int = 0):Point
		{
			var result:Point;
			var w:int = grid[0].length;
			var h:int = grid.length;
			
			rotation = rotation % 4;
			if (rotation < 0)
				rotation += 4;
			
			switch (rotation)
			{
				case 0:
					result = regPoint.clone();
					break;
				case 1:
					result = new Point(h - regPoint.y - 1, regPoint.x);
					break;
				case 2:
					result = new Point(w - regPoint.x - 1, h - regPoint.y - 1);
					break;
				case 3:
					result = new Point(regPoint.y, w - regPoint.x - 1);
					break
			}
			return result;
		}
	}
}