package ghostcat.algorithm.traversal
{
	import flash.geom.Point;

	public class PathOptimizer
	{
		static public function findPath(path:Array,start:Point = null,end:Point = null):Array
		{
			const DX1:Array = [0,0,1,0,0,1,0,1,1];
			const DY1:Array = [0,0,0,1,0,0,1,1,1];
			const DX2:Array = [0,1,1,0,0,1,0,0,1];
			const DY2:Array = [0,0,0,0,0,1,1,1,1];
			
			if (start)
				path[0] = start;
			
			if (end)
				path[path.length - 1] = end;
			
			var cur:Point ;
			var pos:int = 1;
			
			var p1:Point;
			var p2:Point;
			var c1:Point;
			var c2:Point;
			var c:Point;
			
			var result:Array = [path[0]];
			
			cur = path[0];
			c1 = c2 = new Point();
			
			while (pos < path.length)
			{
				p1 = path[pos - 1];
				p2 = path[pos];
				var type:int = (int(p2.y) < int(p1.y) ? 0 : int(p2.y) > int(p1.y) ? 2 : 1) * 3 + (int(p2.x < p1.x) ? 0 : int(p2.x > p1.x) ? 2 : 1);
//				if (c1.x * c2.y - c2.x * c1.y < 0)
//				{
//					var t:Point = c1;
//					c1 = c2;
//					c2 = t;
//				}
//				if (pos > 1)
//				{
//					c = new Point(p1.x + DX1[type] - cur.x, p1.y + DY1[type] - cur.y);
//					if (c1.x * oc1.y - oc1.x * c1.y > 0)
//					{
//						if (oc2 == null)
//						{
//							cur = cur.add(oc1);
//							result.push(cur);
//							
//							c1 = c2 = new Point();
//						}
//						else
//						{
//							c1 = null;
//						}
//					}
//					c = new Point(p1.x + DX2[type] - cur.x, p1.y + DY2[type] - cur.y);
//					if (c2.x * oc2.y - oc2.x * c2.y < 0)
//					{
//						if (oc1 == null)
//						{
//							cur = cur.add(oc2);
//							result.push(cur);
//							
//							c1 = c2 = new Point();
//						}
//						else
//						{
//							c2 = null;
//						}
//					};
//				}
				
				pos++;
			}
			return result;
		}
	}
}