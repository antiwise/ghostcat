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
		private var _map:Array;
		
		/** @inheritDoc */	
		public function get map():Array
		{
			return _map;
		}
		
		public function set map(value:Array):void
		{
			_map = value;
		}
		
		/** @inheritDoc */	
		public function reset():void
		{
			this.noteMap = [];
		}
		
		/** @inheritDoc */	
		public function setNode(v:*,node:TraversalNote):void
		{
			this.noteMap[v] = node;
		}
		
		/** @inheritDoc */	
		public function getNode(v:*):TraversalNote
		{
			return this.noteMap[v];
		}

		
		/** @inheritDoc */	
		public function reachEnd(cur:*,end:*):Boolean
		{
			return cur == end;
		}
		
		/** @inheritDoc */	
		public function getCostAddon(start:*,cur:*,next:*,end:*):int
		{
			return wayMap[cur][next];
		}
		
		/** @inheritDoc */	
		public function getScoreAddon(start:*,cur:*,next:*,end:*):int
		{
			var endPoint:Point = points[end];
			var curPoint:Point = points[cur];
			var nextPoint:Point = points[next];
			
			return Point.distance(nextPoint,endPoint) - Point.distance(curPoint,endPoint);
		}
		
		/** @inheritDoc */	
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
		
		/** @inheritDoc */	
		public function isBlock(v:*,cur:* = null):Boolean
		{
			return v != cur && wayMap[cur][v] > 0;
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