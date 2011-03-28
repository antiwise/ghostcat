package ghostcat.algorithm.traversal
{
	import flash.geom.Point;

	public class PathOptimizer
	{
		static public function findPath(path:Array,start:Point = null,end:Point = null):Array
		{
			const DX1:Array = [0,0,1,0,0,1,0,0,1];
			const DY1:Array = [0,0,0,0,0,0,1,1,1];
			const DX2:Array = [0,1,1,0,0,1,0,1,1];
			const DY2:Array = [0,0,0,1,0,1,1,1,1];
			
			if (start)
				path[0] = start;
			
			if (end)
				path[path.length - 1] = end;
			
			var cur:Point ;
			var pos:int = 1;
			
			var p1:Point;//上一个前坐标
			var p2:Point;//当前坐标
			
			//交线端点
			var c1:Point;
			var c2:Point;
			var change:Boolean;//是否交换两个拐点
			
			var result:Array = [path[0]];
			
			cur = path[0];
			c1 = c2 = new Point();
			
			while (pos < path.length)
			{
				p1 = path[pos - 1];
				p2 = path[pos];
				var type:int = (int(p2.y) < int(p1.y) ? 0 : int(p2.y) > int(p1.y) ? 2 : 1) * 3 + (int(p2.x < p1.x) ? 0 : int(p2.x > p1.x) ? 2 : 1);

				var nc1:Point = new Point(p1.x + DX1[type] - cur.x, p1.y + DY1[type] - cur.y);
				var nc2:Point = new Point(p1.x + DX2[type] - cur.x, p1.y + DY2[type] - cur.y);
				if (change)
				{
					var t:Point = nc1;
					nc1 = nc2;
					nc2 = t;
				}
				
				if (nc1.equals(c2) || nc2.equals(c1))
				{
					change = !change;
					
					t = nc1;
					nc1 = nc2;
					nc2 = t;
				}
				
				if (!c1 || nc1.x * c1.y - c1.x * nc1.y <= 0)
					c1 = nc1;
				
				if (!c2 || nc2.x * c2.y - c2.x * nc2.y >= 0)
					c2 = nc2;
				
				if (c2.x * c1.y - c1.x * c2.y >= 0)
				{
					cur = cur.add(c1.length > c1.length ? c1 : c2);
					result.push(cur);
					
					c1 = c2 = new Point();
				}
				pos++;
			}
			result.push(path[path.length - 1]);
			return result;
		}
	}
}