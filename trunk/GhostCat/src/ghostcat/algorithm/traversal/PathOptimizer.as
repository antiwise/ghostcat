package ghostcat.algorithm.traversal
{
	import flash.geom.Point;

	/**
	 * 寻路路径优化
	 * @author flashyiyi
	 * 
	 */
	public class PathOptimizer
	{
		/**
		 * 在路径通过的网格的范围内寻找最少拐弯的像素精度的直线路径
		 * 
		 * @param path	路径节点数组（网格坐标）
		 * @param start	详细起点（值为浮点数形式的网格坐标）
		 * @param end	详细终点（值为浮点数形式的网格坐标）
		 * @param useShortPath	是否先简化路径。如果输入路径是按8方向方式生成的，结果会出错
		 * @return 
		 * 
		 */
		static public function optimize(path:Array,start:Point = null,end:Point = null,useShortPath:Boolean = true,offest:Number = 0.0):Array
		{
			if (useShortPath)
				path = short(path);
			
			const DX1:Array = [0,0 + offest,1,0,0,1,0,0 + offest,1];
			const DY1:Array = [0,0,0,0 + offest,0,0 + offest,1,1,1];
			const DX2:Array = [0,1 - offest,1,0,0,1,0,1 - offest,1];
			const DY2:Array = [0,0,0,1 - offest,0,1 - offest,1,1,1];
			
			if (start)
				path[0] = start;
			else
				start = path[0];
			
			if (end)
				path[path.length - 1] = end;
			else
				end = path[path.length - 1];
			
			var cur:Point;//视线基准点
			
			var pos:int = 1;//总步骤
			var pos1:int = 1;//左视线前进步骤
			var pos2:int = 1;//右视线前进步骤
			
			//交线端点
			var c1:Point;
			var c2:Point;
			var v:Number;//暂存值
			
			var result:Array = [path[0]];
			
			cur = path[0];
			c1 = c2 = new Point();
			
			while (true)
			{
				if (pos < path.length)
				{
					var p1:Point = path[pos - 1];//上一个坐标
					var p2:Point = path[pos];//当前坐标
					//计算方向
					var type:int = (int(p2.y) < int(p1.y) ? 0 : int(p2.y) > int(p1.y) ? 2 : 1) * 3 + (int(p2.x) < int(p1.x) ? 0 : int(p2.x) > int(p1.x) ? 2 : 1);
					
					//新的交线端点
					var nc1:Point = new Point(int(p1.x) + DX1[type] - cur.x, int(p1.y) + DY1[type] - cur.y);
					var nc2:Point = new Point(int(p1.x) + DX2[type] - cur.x, int(p1.y) + DY2[type] - cur.y);
					
					//判断两端点谁为左端点
					v = nc2.x * nc1.y - nc1.x * nc2.y;
					if (v > 0 || v == 0 && nc1.length > nc2.length)
					{
						var t:Point = nc1;
						nc1 = nc2;
						nc2 = t;
					}
					
					//判断斜率变化，允许范围内才可以前进
					if (nc1.x * c1.y - c1.x * nc1.y <= 0)
					{
						c1 = nc1;
						pos1++;
					}
					if (nc2.x * c2.y - c2.x * nc2.y >= 0)
					{
						c2 = nc2;
						pos2++;
					}
					
					pos++;
					
					//当左右射线交叉后，认为出现拐点
					if (c2.x * c1.y - c1.x * c2.y >= 0)
					{
						pos = pos2 = pos1 = Math.min(pos1,pos2);
						cur = cur.add(c1.length < c2.length ? c1 : c2);
						c1 = c2 = new Point();
						
						result.push(cur);
					}
				}
				else
				{
					//终点判断，两条视线都必须能够到达终点
					nc1 = nc2 = new Point(end.x - cur.x,end.y - cur.y);
					if (nc1.x * c1.y - c1.x * nc1.y <= 0 && nc2.x * c2.y - c2.x * nc2.y >= 0)
					{
						result.push(path[path.length - 1]);
						return result;
					}
					else
					{
						pos = pos2 = pos1 = Math.min(pos1,pos2);
						cur = cur.add(c1.length < c2.length ? c1 : c2);
						c1 = c2 = new Point();
						
						result.push(cur);
					}
				}
			}
			
			return null;
		}
		
		/**
		 * 获得只有拐点的短路径
		 * @param path	路径点数组（网格坐标）
		 * @return 
		 * 
		 */
		static public function short(path:Array):Array
		{
			path = path.concat();
			
			var oldType:int = -1;
			var result:Array = [];
			var p1:Point = path.shift();
			while (path.length)
			{
				var p2:Point = path.shift();
				var type:int = (int(p2.y) < int(p1.y) ? 0 : int(p2.y) > int(p1.y) ? 2 : 1) * 3 + (int(p2.x) < int(p1.x) ? 0 : int(p2.x) > int(p1.x) ? 2 : 1);
				
				if (type != oldType)
					result.push(p1);
				
				oldType = type;
				p1 = p2;
			}
			result.push(p2);
			return result;
		}
	}
}