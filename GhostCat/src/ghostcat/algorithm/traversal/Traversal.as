package ghostcat.algorithm.traversal
{
	import ghostcat.util.core.AbstractUtil;

	/**
	 * 遍历算法基类
	 * 数据源必须实现IMapModel
	 * 
	 * @author flashyiyi
	 */	
	public class Traversal
	{
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
		
		public function Traversal(mapModel : MapModel, maxTry : int = 5000)
		{
			AbstractUtil.preventConstructor(this,Traversal,"Traversal为抽象类，必须实现find方法！");
			
			this.mapModel = mapModel;
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
			//在这里添加遍历方法
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