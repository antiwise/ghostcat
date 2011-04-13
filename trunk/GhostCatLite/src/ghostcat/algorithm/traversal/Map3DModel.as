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
		static public const COST_STRAIGHT : int = 10;//水平分值
		static public const COST_DIAGONAL : int = 14;//斜向分值
		static public const COST_DIAGONAL_3D : int = 17;//3D斜向分值
		
		/**
		 * 地图宽度 
		 */
		public var width:int;
		
		/**
		 * 地图高度
		 */
		public var height:int;
		
		/**
		 * 地图深度
		 */
		public var depth:int;
		
		/**
		 * 是否启用斜向移动
		 */		
		public var diagonal:Boolean = true;
		
		private var _map : Array;
		private var noteMap : Array;//node缓存
		private var isArray2D:Boolean;//是否是二维数组
		
		public function Map3DModel(map:Array = null)
		{
			if (map)
				this.map = map;
		}
		
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
			
			if (value[0] is Array)
			{
				width = (value[0] as Array).length;
				height = value.length;
				depth = (value[0][0] as Array).length;
				isArray2D = true;
			}
			else
			{
				isArray2D = false;
			}
		}

		/**
		 * 初始化
		 * 
		 */
		public function reset():void
		{
			this.noteMap = new Array(width * height * depth);
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
			var p:Point3D = Point3D(v);
			this.noteMap[p.z * width * height + p.y * width + p.x] = node;
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
			var p:Point3D = Point3D(v);
			return this.noteMap[p.z * width * height + p.y * width + p.x];
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
			var p1:Point3D = Point3D(cur);
			var p2:Point3D = Point3D(next);
			var equelCount:int = 0;
			if (p2.x == p1.x)
				equelCount++;
			if (p2.y == p1.y)
				equelCount++;
			if (p2.z == p1.z)
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
			var p1:Point3D = Point3D(next);
			var p2:Point3D = Point3D(end);
			return (Math.abs(p2.x - p1.x) + Math.abs(p2.y - p1.y) + Math.abs(p2.z - p1.z)) * COST_STRAIGHT;
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
			var p:Point3D = Point3D(v);
			var result:Array = [];
			var t:Point3D;
			var canDiagonal:Boolean;
			
			//右
			t = new Point3D(p.x + 1, p.y, p.z);
			var canRight : Boolean = !isBlock(t);
			if (canRight)
				result[result.length] = t;
			
			//下
			t = new Point3D(p.x, p.y + 1, p.z);
			var canDown : Boolean = !isBlock(t);
			if (canDown)
				result[result.length] = t;
			
			//左
			t = new Point3D(p.x - 1, p.y, p.z);
			var canLeft : Boolean = !isBlock(t);
			if (canLeft)
				result[result.length] = t;
			
			//上
			t = new Point3D(p.x, p.y - 1, p.z);
			var canUp : Boolean = !isBlock(t);
			if (canUp)
				result[result.length] = t;
				
			//前
			t = new Point3D(p.x, p.y, p.z + 1);
			var canFront : Boolean = !isBlock(t);
			if (canFront)
				result[result.length] = t;
			
			//后
			t = new Point3D(p.x, p.y, p.z - 1);
			var canBehind : Boolean = !isBlock(t);
			if (canBehind)
				result[result.length] = t;
				
			if (diagonal)
			{
				//右下
				t = new Point3D(p.x + 1, p.y + 1, p.z);
				canDiagonal = !isBlock(t);
				if (canDiagonal && canRight && canDown)
					result[result.length] = t;
				
				//左下
				t = new Point3D(p.x - 1, p.y + 1, p.z);
				canDiagonal = !isBlock(t);
				if (canDiagonal && canLeft && canDown)
					result[result.length] = t;
				
				//左上
				t = new Point3D(p.x - 1, p.y - 1, p.z);
				canDiagonal = !isBlock(t);
				if (canDiagonal && canLeft && canUp)
					result[result.length] = t;
				
				//右上
				t = new Point3D(p.x + 1, p.y - 1, p.z);
				canDiagonal = !isBlock(t);
				if (canDiagonal && canRight && canUp)
					result[result.length] = t;
					
				/////////////////////////////////////////
				
				if (canFront)
				{
					//前右下
					t = new Point3D(p.x + 1, p.y + 1, p.z + 1);
					canDiagonal = !isBlock(t);
					if (canDiagonal && canRight && canDown)
						result[result.length] = t;
					
					//前左下
					t = new Point3D(p.x - 1, p.y + 1, p.z + 1);
					canDiagonal = !isBlock(t);
					if (canDiagonal && canLeft && canDown)
						result[result.length] = t;
					
					//前左上
					t = new Point3D(p.x - 1, p.y - 1, p.z + 1);
					canDiagonal = !isBlock(t);
					if (canDiagonal && canLeft && canUp)
						result[result.length] = t;
					
					//前右上
					t = new Point3D(p.x + 1, p.y - 1, p.z + 1);
					canDiagonal = !isBlock(t);
					if (canDiagonal && canRight && canUp)
						result[result.length] = t;
				}	
				////////////////////////////////////	
				
				if (canBehind)
				{
					//后右下
					t = new Point3D(p.x + 1, p.y + 1, p.z - 1);
					canDiagonal = !isBlock(t);
					if (canDiagonal && canRight && canDown)
						result[result.length] = t;
					
					//后左下
					t = new Point3D(p.x - 1, p.y + 1, p.z - 1);
					canDiagonal = !isBlock(t);
					if (canDiagonal && canLeft && canDown)
						result[result.length] = t;
					
					//后左上
					t = new Point3D(p.x - 1, p.y - 1, p.z - 1);
					canDiagonal = !isBlock(t);
					if (canDiagonal && canLeft && canUp)
						result[result.length] = t;
					
					//后右上
					t = new Point3D(p.x + 1, p.y - 1, p.z - 1);
					canDiagonal = !isBlock(t);
					if (canDiagonal && canRight && canUp)
						result[result.length] = t;
				}
			}
			return result;
		}
		
		public function isBlock(v:*,cur:* = null):Boolean
		{
			var p:Point3D = Point3D(v);
			if (p.x < 0 || p.x >= width || p.y < 0 || p.y >= height || p.z < 0 || p.z >= depth)
				return true;
			else
				return isArray2D ? _map[p.z][p.y][p.x] : _map[p.z * width * height + p.y * width + p.x];
		}
	}
}