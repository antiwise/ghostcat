package ghostcat.algorithm.traversal
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	/**
	 * 网格地图模型类
	 * 
	 */	
	public class MapModel implements IMapModel
	{
		private const COST_STRAIGHT : int = 10;//水平分值
		
		private const COST_DIAGONAL : int = 14;//斜向分值
		
		
		/**
		 * 是否启用斜向移动
		 */		
		public var diagonal:Boolean = true;
		
		public function MapModel(map:Array = null)
		{
			if (map)
				this.map = map;
		}
		
		private var noteMap : Array;//node缓存
		private var _map:Array;
		
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
			if (this.noteMap[v.y] == null)
				this.noteMap[v.y] = [];
			this.noteMap[v.y][v.x] = node;
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
			if (this.noteMap[v.y] == null) 
				return null;
			return this.noteMap[v.y][v.x];
		}

		
		/**
		 * 判断是否到达终点
		 * 
		 * @param p1	节点1
		 * @param p2	节点2
		 * @return 	是否相同的布尔值
		 * 
		 */
		public function reachEnd(cur:*,end:*):Boolean
		{
			return (cur as Point).equals(end as Point);
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
			return (next.x == cur.x || next.y == cur.y) ? COST_STRAIGHT : COST_DIAGONAL;
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
			return (Math.abs(end.x - next.x) + Math.abs(end.y - next.y)) * COST_STRAIGHT;
		}
		
		/**
		 * 提供可遍历的节点
		 * 
		 * 这里提供的是八方向移动
		 * 
		 * @param p	当前节点
		 * @return 
		 * 
		 */
		public function getArounds(v:*) : Array
		{
			var result : Array = [];
			var cur : Point = new Point(v.x,v.y);
			var p : Point;
			var canDiagonal : Boolean;
			
			//右
			p = new Point(v.x + 1, v.y);
			var canRight : Boolean = !isBlock(p,cur);
			if (canRight)
				result.push(p);
			
			//下
			p = new Point(v.x, v.y + 1);
			var canDown : Boolean = !isBlock(p,cur);
			if (canDown)
				result.push(p);
			
			//左
			p = new Point(v.x - 1, v.y);
			var canLeft : Boolean = !isBlock(p,cur);
			if (canLeft)
				result.push(p);
			
			//上
			p = new Point(v.x, v.y - 1);
			var canUp : Boolean = !isBlock(p,cur);
			if (canUp)
				result.push(p);
				
			if (diagonal)
			{
				//右下
				p = new Point(v.x + 1, v.y + 1);
				canDiagonal = !isBlock(p,cur);
				if (canDiagonal && canRight && canDown)
					result.push(p);
				
				//左下
				p = new Point(v.x - 1, v.y + 1);
				canDiagonal = !isBlock(p,cur);
				if (canDiagonal && canLeft && canDown)
					result.push(p);
				
				//左上
				p = new Point(v.x - 1, v.y - 1);
				canDiagonal = !isBlock(p,cur);
				if (canDiagonal && canLeft && canUp)
					result.push(p);
				
				//右上
				p = new Point(v.x + 1, v.y - 1);
				canDiagonal = !isBlock(p,cur);
				if (canDiagonal && canRight && canUp)
					result.push(p);
			}
			return result;
		}
		
		/**
		 * 是否是墙壁
		 * @param v	目标点
		 * @param cur	当前点
		 * @return 
		 * 
		 */
		protected function isBlock(v:Point,cur:Point):Boolean
		{
			var mapHeight : int = _map.length;
			var mapWidth : int = _map[0].length;
			
			if (v.x < 0 || v.x >= mapWidth || v.y < 0 || v.y >= mapHeight)
				return true;
			
			return _map[v.y][v.x];
		}
		
		/**
		 * 转换为位图显示 
		 * @param source
		 * @return 
		 * 
		 */
		public function toBitmap():Bitmap
		{
			var bitmap:Bitmap =  new Bitmap(new BitmapData(_map[0].length,_map.length))
			for (var j:int = 0;j < _map.length;j++)
			{
				for (var i:int = 0;i < _map[j].length;i++)
				{
					if (_map[j][i])
						bitmap.bitmapData.setPixel(i,j,0x0);
				}
			}
			return bitmap;
		}
	}
}