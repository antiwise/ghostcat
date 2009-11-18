package ghostcat.algorithm.traversal
{
	/**
	 * 遍历算法
	 * 数据源必须实现IMapModel
	 * 
	 * @author flashyiyi
	 */	
	public class Traversal
	{
		/**
		 * 深度优先遍历 Depth-First-Search
		 */
		static public const DFS:String = "dfs";
		
		/**
		 * 广度优先遍历 Breadth-First-Search
		 */
		static public const BFS:String = "bfs";
		
		/**
		 * 最长限制步数
		 */
		public var maxTry : int;
		
		/**
		 * 地图模型 
		 */
		protected var mapModel : IMapModel;
		
		/**
		 * 开放列表 
		 */
		protected var openList : Array;
		
		private var type:String = "dfs";//遍历方式
		
		public function Traversal(mapModel : MapModel, type:String = "dfs", maxTry : int = 5000)
		{
			this.mapModel = mapModel;
			this.type = type;
			this.maxTry = maxTry;
		}
		
		/**
		 * 计算两个坐标之间的路径
		 * 
		 * @param startP	开始坐标
		 * @param endP	结束坐标
		 * @return	一个数组，为中间步骤的坐标 
		 * 
		 */
		public function find(start:*, end:*) : Array
		{
			this.openList = [];
			
			mapModel.reset();
			
			var curTry : int = 0;
			
			this.openNote(start, 0, 0, null);//建立首节点
			
			while (this.openList.length > 0)
			{
				if (++curTry > this.maxTry)
					return null;
				
				var cur:TraversalNote;
				if (type == DFS)
					cur = this.openList.pop();
				else
					cur = this.openList.shift();
					
				//获得最前的节点，并将它加入关闭列表
				this.closeNote(cur);
				
				var curPoint : * = cur.point;
				
				//如果到达终点
				if (mapModel.reachEnd(curPoint,end))
					return this.getPath(start, cur);
				
				var aroundNotes : Array = mapModel.getArounds(curPoint);
				
				for each (var p : * in aroundNotes)
				{
					var n:TraversalNote = mapModel.getNode(p);
					if (n && n.noteClosed)//在关闭列表中则跳过
						continue;
					
					//在这里计算F和G值
					if (n && n.noteOpen) //如果节点已在开放列表中
					{
						//在这里更新F和G值
					}
					else	//否则加入开放列表 
						this.openNote(p, 0, 0, cur);
				}
			}
			return null;
		}
		
		/**
		 * 加入开放列表
		 * 
		 * @param p
		 * @param score
		 * @param cost
		 * @param parent
		 * 
		 */
		protected function openNote(p : *, score : int, cost : int, parent : TraversalNote)  : void
		{
			var node:TraversalNote = new TraversalNote();
			node.point = p;
			node.score = score;
			node.cost = cost;
			node.parent = parent;
			
			mapModel.setNode(p,node);
			
			this.openList.push(node);
		}
		
		/**
		 * 加入关闭列表
		 * @param node
		 * 
		 */
		protected function closeNote(node : TraversalNote) : void
		{
			node.noteOpen = false;
			node.noteClosed = true;
		}
		
		/**
		 * 获得返回路径
		 * 
		 * @param start
		 * @param node
		 * @return 
		 * 
		 */
		protected function getPath(start:*, node:TraversalNote) : Array
		{
			var arr : Array = [];
			var cur:* = node.point;
			while (!mapModel.reachEnd(cur,start))
			{
				arr.unshift(cur);
				node = node.parent;
				cur = node.point;
			}
			arr.unshift(start);
			return arr;
		}
	}
}