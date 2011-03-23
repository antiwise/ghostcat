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
		static public const COST_STRAIGHT : int = 10;//水平分值
		static public const COST_DIAGONAL : int = 14;//斜向分值
		
		/**
		 * 地图宽度 
		 */
		public var width:int;
		
		/**
		 * 地图高度
		 */
		public var height:int;
		
		/**
		 * 是否启用斜向移动
		 */		
		public var diagonal:Boolean = true;
		
		protected var noteMap:Array;//node缓存
		protected var _map:Array;//地图
		protected var isArray2D:Boolean;//是否是二维数组
		
		public function MapModel(map:Array = null)
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
				isArray2D = true;
			}
			else
			{
				isArray2D = false;
			}
		}
		
		/**
		 * 创建地图 
		 * @param width
		 * @param height
		 * @param isArray2D
		 * 
		 */
		public function createMap(width:int,height:int,isArray2D:Boolean = false):void
		{
			var m:Array = [];
			
			if (isArray2D)
			{
				for (var j:int = 0;j < height;j++)
				{
					var line:Array = [];
					for (var i:int = 0;i < width;i++)
						line[i] = false;
					
					m[j] = line;
				}
			}
			else
			{
				var l:int = width * height;
				for (i = 0;i < l;i++)
					m[i] = false;
			}
			
			this.map = m;
		}
		
		/**
		 * 初始化
		 * 
		 */
		public function reset():void
		{
			this.noteMap = new Array(width * height);
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
			var p:Point = Point(v);
			this.noteMap[p.y * width + p.x] = node;
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
			var p:Point = Point(v);
			return this.noteMap[p.y * width + p.x];
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
			return Point(cur).equals(Point(end));
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
			var p1:Point = Point(cur);
			var p2:Point = Point(next);
			return (p1.x == p2.x || p1.y == p2.y) ? COST_STRAIGHT : COST_DIAGONAL;
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
			var p1:Point = Point(next);
			var p2:Point = Point(end);
			return (Math.abs(p2.x - p1.x) + Math.abs(p2.y - p1.y)) * COST_STRAIGHT;
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
			var p:Point = Point(v);
			var result : Array = [];
			var cur : Point = new Point(p.x,p.y);
			var t : Point;
			var canDiagonal : Boolean;
			
			//右
			t = new Point(p.x + 1, p.y);
			var canRight : Boolean = !isBlock(t,cur);
			if (canRight)
				result[result.length] = t;
			
			//下
			t = new Point(p.x, p.y + 1);
			var canDown : Boolean = !isBlock(t,cur);
			if (canDown)
				result[result.length] = t;
			
			//左
			t = new Point(p.x - 1, p.y);
			var canLeft : Boolean = !isBlock(t,cur);
			if (canLeft)
				result[result.length] = t;
			
			//上
			t = new Point(p.x, p.y - 1);
			var canUp : Boolean = !isBlock(t,cur);
			if (canUp)
				result[result.length] = t;
				
			if (diagonal)
			{
				//右下
				t = new Point(p.x + 1, p.y + 1);
				canDiagonal = !isBlock(t,cur);
				if (canDiagonal && canRight && canDown)
					result[result.length] = t;
				
				//左下
				t = new Point(p.x - 1, p.y + 1);
				canDiagonal = !isBlock(t,cur);
				if (canDiagonal && canLeft && canDown)
					result[result.length] = t;
				
				//左上
				t = new Point(p.x - 1, p.y - 1);
				canDiagonal = !isBlock(t,cur);
				if (canDiagonal && canLeft && canUp)
					result[result.length] = t;
				
				//右上
				t = new Point(p.x + 1, p.y - 1);
				canDiagonal = !isBlock(t,cur);
				if (canDiagonal && canRight && canUp)
					result[result.length] = t;
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
		public function isBlock(v:*,cur:* = null):Boolean
		{
			var p:Point = Point(v);
			if (p.x < 0 || p.x >= width || p.y < 0 || p.y >= height)
				return true;
			else
				return isArray2D ? _map[p.y][p.x] : _map[p.y * width + p.x];
		}
		
		/**
		 * 转换为位图显示 
		 * @param source
		 * @return 
		 * 
		 */
		public function toBitmap():Bitmap
		{
			var bitmap:Bitmap =  new Bitmap(new BitmapData(width,height))
			for (var j:int = 0;j < height;j++)
			{
				for (var i:int = 0;i < width;i++)
				{
					if (isBlock(new Point(i,j)))
						bitmap.bitmapData.setPixel(i,j,0x0);
				}
			}
			return bitmap;
		}
	}
}