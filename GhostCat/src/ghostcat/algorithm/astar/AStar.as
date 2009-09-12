package ghostcat.algorithm.astar
{
	import ghostcat.algorithm.BinaryHeap;

	/**
	 * A* 通用寻路算法
	 * 
	 * 通过接口扩展了功能，可用于非网格型寻路，由此增加了调用层次，会比一般的寻路要慢。
	 * 数据源必须实现IMapModel
	 * 
	 * @author flashyiyi
	 */	
	public class AStar
	{
		private var mapModel : IMapModel;//地图模型
		
		private var openList : BinaryHeap;//开放列表，为二叉堆，将自动排序
		
		/**
		 * 最长限制步数
		 */
		public var maxTry : int;
		
		public function AStar(mapModel : MapModel, maxTry : int = 5000)
		{
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
			this.openList = new BinaryHeap();
			this.openList.sortMetord = sortMetord;
			
			mapModel.reset();
			
			var curTry : int = 0;
			
			this.openNote(start, 0, 0, null);//建立首节点
			
			while (this.openList.length > 0)
			{
				if (++curTry > this.maxTry)
					return null;
				
				//获得最小F值的节点，并将它加入关闭列表
				var cur : Node = this.openList.shift();
				this.closeNote(cur);
				
				var curPoint : * = cur.point;
				
				//如果到达终点
				if (mapModel.reachEnd(curPoint,end))
					return this.getPath(start, cur);
				
				var aroundNotes : Array = mapModel.getArounds(curPoint);
				
				for each (var p : * in aroundNotes)
				{
					var n:Node = mapModel.getNode(p);
					if (n && n.noteClosed)//在关闭列表中则跳过
						continue;
					
					//计算F和G值
					var cost : int = cur.cost + mapModel.getCostAddon(start,curPoint,p,end);
					var score : int = cost + mapModel.getScoreAddon(start,curPoint,p,end);;
					if (n && n.noteOpen) //如果节点已在开放列表中
					{
						//如果新的G值比节点原来的G值小,修改F,G值，重新排序
						if (cost < n.cost)
						{
							n.cost = cost;
							n.score = score;
							n.parent = cur;
							this.openList.modify(n);
						}
					}
					else	//否则加入开放列表 
						this.openNote(p, score, cost, cur);
				}
			}
			return null;
		}
		
		//加入开放列表
		private function openNote(p : *, score : int, cost : int, parent : Node) : void
		{
			var node:Node = new Node();
			
			node.point = p;
			node.score = score;
			node.cost = cost;
			node.parent = parent;
			
			mapModel.setNode(p,node);
			
			this.openList.push(node);
		}
		
		//加入关闭列表
		private function closeNote(node : Node) : void
		{
			node.noteOpen = false;
			node.noteClosed = true;
		}
		
		
		//获得返回路径
		private function getPath(start:*, node:Node) : Array
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
		
		//分值排序方法
		private function sortMetord(n1:Node,n2:Node):Boolean
		{
			return n1.score < n2.score;
		}
	}
}
import flash.geom.Point;

class Node
{
	public var noteOpen : Boolean = true;//是否在开放列表
	public var noteClosed : Boolean = false;//是否在关闭列表
	public var parent:Node;//父节点
	public var point:*;//坐标
	public var cost:Number;//距离消耗
	public var score:Number;//节点得分
}