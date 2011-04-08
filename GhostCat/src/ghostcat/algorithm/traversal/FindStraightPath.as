package ghostcat.algorithm.traversal
{
	import flash.geom.Point;

	/**
	 * 从两点间寻找一条直线路径，中间遇到阻碍则返回空
	 * @author flashyiyi
	 * 
	 */
	public final class FindStraightPath
	{
		/**
		 * 
		 * @param map
		 * @param start
		 * @param end
		 * @param diagonal	是否八方向
		 * @return 
		 * 
		 */
		public static function find(map:IMapModel,start:Point,end:Point,diagonal:Boolean = true):Array
		{
			var startX:int = start.x;
			var startY:int = start.y;
			var endX:int = end.x;
			var endY:int = end.y;
			var lx:int = Math.abs(endX - startX);
			var ly:int = Math.abs(endY - startY);
			var k:Number = (endY - startY) / (endX - startX);
			var offestX:int = endX > startX ? 1 : -1;
			var offestY:int = endY > startY ? 1 : -1;
			
			var i:int;
			var j:int;
			var p:Point;
			var corner:Point;
			var old:Point = start.clone();
			var result:Array = [];
			
			if (lx > ly)
			{
				for (i = 0;i <= lx;i++)
				{
					j = k ? Math.round(i * offestX * k) : 0;
					p = new Point(startX + i * offestX,startY + j);
					if (map.isBlock(p))
						return null;
					
					if (p.y != old.y)
					{
						if (!map.isBlock(new Point(p.x, old.y)))
							corner = new Point(p.x, old.y);
						else if (!map.isBlock(new Point(old.x, p.y)))
							corner = new Point(old.x, p.y);
						else
							return null;
						
						if (!diagonal)
							result[result.length] = corner;
					}
					
					result[result.length] = p;
					old = p.clone();
				}
			}
			else
			{
				
				for (j = 0;j <= ly;j++)
				{
					i = k ? Math.round(j * offestY / k) : 0;
					p = new Point(startX + i,startY + j * offestY);
					if (map.isBlock(p))
						return null;
					
					if (p.x != old.x)
					{
						if (!map.isBlock(new Point(old.x, p.y)))
							corner = new Point(old.x, p.y);
						else if (!map.isBlock(new Point(p.x, old.y)))
							corner = new Point(p.x, old.y);
						else
							return null;
						
						if (!diagonal)
							result[result.length] = corner;
					}
					
					result[result.length] = p;
					old = p.clone();
				}
			}
			return result;
		}
	}
}