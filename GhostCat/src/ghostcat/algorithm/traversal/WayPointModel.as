package ghostcat.algorithm.traversal
{
	import flash.geom.Point;

	/**
	 * 路点模型
	 * 
	 * 负值为不连接
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class WayPointModel implements IMapModel
	{
		/**
		 * 位置数据（每个数据对应的坐标）
		 */
		public var points : Array;
		
		/**
		 * 连接数据（二维数组，表示每个数据之间的距离，为负则表示未连接）
		 */
		public var wayMap : Array;
		
		public function WayPointModel(points:Array = null, wayMap:Array = null)
		{
			if (points)
				this.points = points;
		
			if (wayMap)
				this.wayMap = wayMap;
		}
		
		private var noteMap : Array;//node缓存
		
		/**
		 * 初始化
		 * 
		 */
		public function reset():void
		{
			this.noteMap = [];
		}
		
		/**
		 * 保存Node
		 * 
		 * @param v	键
		 * @param node
		 * 
		 */
		public function setNode(v:*,node:TraversalNote):void
		{
			this.noteMap[v] = node;
		}
		
		/**
		 * 取出Node
		 * 
		 * @param v	键
		 * @return 
		 * 
		 */
		public function getNode(v:*):TraversalNote
		{
			return this.noteMap[v];
		}

		
		/**
		 * 判断两个节点是否相同
		 * 
		 * @param p1	节点1
		 * @param p2	节点2
		 * @return 	是否相同的布尔值
		 * 
		 */
		public function reachEnd(cur:*,end:*):Boolean
		{
			return cur == end;
		}
		
		/**
		 * 获得Cost对于父节点Cost的加值
		 * 
		 * @param start	首节点
		 * @param cur	父节点
		 * @param next	当前节点
		 * @param end	终点
		 * @return 
		 * 
		 */
		public function getCostAddon(start:*,cur:*,next:*,end:*):int
		{
			return wayMap[cur][next];
		}
		
		/**
		 * 获得Score对于Cost的加值
		 *  
		 * @param start	首节点
		 * @param cur	父节点
		 * @param next	当前节点
		 * @param end	终点
		 * @return 
		 * 
		 */
		public function getScoreAddon(start:*,cur:*,next:*,end:*):int
		{
			var endPoint:Point = points[end];
			var curPoint:Point = points[cur];
			var nextPoint:Point = points[next];
			
			return Point.distance(nextPoint,endPoint) - Point.distance(curPoint,endPoint);
		}
		
		/**
		 * 提供可遍历的节点
		 * 
		 * 
		 * @param v	当前节点
		 * @return 
		 * 
		 */
		public function getArounds(v:*) : Array
		{
			var result : Array = [];
			var curWayMap : Array = wayMap[v];
			
			for (var i : int = 0;i < curWayMap.length;i++)
			{
				if (v != i && curWayMap[i] > 0)
					result.push(i);
			}
			return result;
		}
		
		public function toString():String
		{
			var r:String = "";
			for (var j:int = 0;j < wayMap.length;j++)
			{
				for (var i:int = 0;i < wayMap.length;i++)
				{
					r += wayMap[i][j] ? "0" : "1"
				}
				r+="\n";
			}
			return r;
		}
	}
}