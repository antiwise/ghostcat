package ghostcat.algorithm.traversal
{
	import ghostcat.algorithm.Point3D;

	/**
	 * 3D网格寻路模型类
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class Map3DModel implements IMapModel
	{
		private const COST_STRAIGHT : int = 10;//水平分值
		
		private const COST_DIAGONAL : int = 14;//斜向分值
		
		private const COST_DIAGONAL_3D : int = 17;//3D斜向分值
		
		private var _map : Array;
		
		/**
		 * 是否启用斜向移动
		 */		
		public var diagonal:Boolean = true;
		
		public function Map3DModel(map:Array = null)
		{
			if (map)
				this.map = map;
		}
		
		private var noteMap : Array;//node缓存
		
		/**
		 * 地图数据
		 */
		public function get map():Array
		{
			return _map;
		}

		public function set map(value:Array):void
		{
			_map = value;
		}

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
			if (this.noteMap[v.z] == null)
				this.noteMap[v.z] = [];
			if (this.noteMap[v.z][v.y] == null)
				this.noteMap[v.z][v.y] = [];
			this.noteMap[v.z][v.y][v.x] = node;
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
			if (this.noteMap[v.z] == null) 
				return null;
			if (this.noteMap[v.z][v.y] == null) 
				return null;
			return this.noteMap[v.z][v.y][v.x];
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
			return (cur as Point3D).equals(end as Point3D);
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
			var equelCount:int = 0;
			if (next.x == cur.x)
				equelCount++;
			if (next.y == cur.y)
				equelCount++;
			if (next.z == cur.z)
				equelCount++;
			
			if (equelCount == 3)
				return 0;
				
			return (equelCount == 2) ? COST_STRAIGHT : (equelCount == 1) ? COST_DIAGONAL : COST_DIAGONAL_3D;
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
			return (Math.abs(end.x - next.x) + Math.abs(end.y - next.y) + Math.abs(end.z - next.z)) * COST_STRAIGHT;
		}
		
		/**
		 * 提供可遍历的节点
		 * 
		 * @param v	当前节点
		 * @return 
		 * 
		 */
		public function getArounds(v:*) : Array
		{
			var result : Array = [];
			var p : Point3D;
			var canDiagonal : Boolean;
			
			//右
			p = new Point3D(v.x + 1, v.y, v.z);
			var canRight : Boolean = !isBlock(p);
			if (canRight)
				result.push(p);
			
			//下
			p = new Point3D(v.x, v.y + 1, v.z);
			var canDown : Boolean = !isBlock(p);
			if (canDown)
				result.push(p);
			
			//左
			p = new Point3D(v.x - 1, v.y, v.z);
			var canLeft : Boolean = !isBlock(p);
			if (canLeft)
				result.push(p);
			
			//上
			p = new Point3D(v.x, v.y - 1, v.z);
			var canUp : Boolean = !isBlock(p);
			if (canUp)
				result.push(p);
				
			//前
			p = new Point3D(v.x, v.y, v.z + 1);
			var canFront : Boolean = !isBlock(p);
			if (canFront)
				result.push(p);
			
			//后
			p = new Point3D(v.x, v.y, v.z - 1);
			var canBehind : Boolean = !isBlock(p);
			if (canBehind)
				result.push(p);
				
			if (diagonal)
			{
				//右下
				p = new Point3D(v.x + 1, v.y + 1, v.z);
				canDiagonal = !isBlock(p);
				if (canDiagonal && canRight && canDown)
					result.push(p);
				
				//左下
				p = new Point3D(v.x - 1, v.y + 1, v.z);
				canDiagonal = !isBlock(p);
				if (canDiagonal && canLeft && canDown)
					result.push(p);
				
				//左上
				p = new Point3D(v.x - 1, v.y - 1, v.z);
				canDiagonal = !isBlock(p);
				if (canDiagonal && canLeft && canUp)
					result.push(p);
				
				//右上
				p = new Point3D(v.x + 1, v.y - 1, v.z);
				canDiagonal = !isBlock(p);
				if (canDiagonal && canRight && canUp)
					result.push(p);
					
				/////////////////////////////////////////
				
				if (canFront)
				{
					//前右下
					p = new Point3D(v.x + 1, v.y + 1, v.z + 1);
					canDiagonal = !isBlock(p);
					if (canDiagonal && canRight && canDown)
						result.push(p);
					
					//前左下
					p = new Point3D(v.x - 1, v.y + 1, v.z + 1);
					canDiagonal = !isBlock(p);
					if (canDiagonal && canLeft && canDown)
						result.push(p);
					
					//前左上
					p = new Point3D(v.x - 1, v.y - 1, v.z + 1);
					canDiagonal = !isBlock(p);
					if (canDiagonal && canLeft && canUp)
						result.push(p);
					
					//前右上
					p = new Point3D(v.x + 1, v.y - 1, v.z + 1);
					canDiagonal = !isBlock(p);
					if (canDiagonal && canRight && canUp)
						result.push(p);
				}	
				////////////////////////////////////	
				
				if (canBehind)
				{
					//后右下
					p = new Point3D(v.x + 1, v.y + 1, v.z - 1);
					canDiagonal = !isBlock(p);
					if (canDiagonal && canRight && canDown)
						result.push(p);
					
					//后左下
					p = new Point3D(v.x - 1, v.y + 1, v.z - 1);
					canDiagonal = !isBlock(p);
					if (canDiagonal && canLeft && canDown)
						result.push(p);
					
					//后左上
					p = new Point3D(v.x - 1, v.y - 1, v.z - 1);
					canDiagonal = !isBlock(p);
					if (canDiagonal && canLeft && canUp)
						result.push(p);
					
					//后右上
					p = new Point3D(v.x + 1, v.y - 1, v.z - 1);
					canDiagonal = !isBlock(p);
					if (canDiagonal && canRight && canUp)
						result.push(p);
				}
			}
			return result;
		}
		
		//是否是墙壁
		private function isBlock(v:Point3D):Boolean
		{
			var mapDeep : int = _map.length;
			var mapHeight : int = _map[0].length;
			var mapWidth : int = _map[0][0].length;
			
			if (v.x < 0 || v.x >= mapWidth || v.y < 0 || v.y >= mapHeight || v.z < 0 || v.z >= mapDeep)
				return true;
			
			return _map[v.z][v.y][v.x];
		}
	}
}