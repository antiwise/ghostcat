package ghostcat.algorithm.traversal
{
	/**
	 * A* 通用寻路算法
	 * 
	 * 通过接口扩展了功能，可用于非网格型寻路，由此增加了调用层次，会比一般的寻路要慢。
	 * 数据源必须实现IMapModel
	 * 
	 * @author flashyiyi
	 */	
	public class AStar extends Traversal
	{
		protected var heapOpenList : BinaryHeap;//开放列表，为二叉堆，将自动排序
		
		public function AStar(mapModel : MapModel, maxTry : int = 5000)
		{
			super(mapModel,maxTry);
		}
		
		/** @inheritDoc*/
		public override function find(start:*, end:*) : Array
		{
			this.heapOpenList = new BinaryHeap();
			this.heapOpenList.sortMetord = sortMetord;
				
			mapModel.reset();
			var curTry : int = 0;
			
			this.openNote(start, 0, 0, null);//建立首节点
			
			while (this.heapOpenList.length > 0)
			{
				if (++curTry > this.maxTry)
					return null;
				
				var cur:TraversalNote = this.heapOpenList.shift()
				//获得最前的节点，并将它加入关闭列表
				this.closeNote(cur);
				
				var curPoint : * = cur.point;
				
				//如果到达终点
				if (mapModel.reachEnd(curPoint,end))
					return this.getPath(start, cur);
				
				var aroundNotes : Array = mapModel.getArounds(cur.point);
				for each (var p : * in aroundNotes)
				{
					var n:TraversalNote = mapModel.getNode(p);
					if (n && n.noteClosed)//在关闭列表中则跳过
						continue;
					
					//计算F和G值
					var cost : int = cur.cost + mapModel.getCostAddon(start,cur.point,p,end);
					var score : int = cost + mapModel.getScoreAddon(start,cur.point,p,end);;
					if (n && n.noteOpen) //如果节点已在开放列表中
					{
						//如果新的G值比节点原来的G值小,修改F,G值，重新排序
						if (cost < n.cost)
						{
							n.cost = cost;
							n.score = score;
							n.parent = cur;
							this.heapOpenList.modify(n);
						}
					}
					else	//否则加入开放列表 
						this.openNote(p, score, cost, cur);
				}
			}
			return null;
		}
		
		/** @inheritDoc*/
		protected override function openNote(p : *, score : int, cost : int, parent : TraversalNote)  : void
		{
			var node:TraversalNote = new TraversalNote();
			node.point = p;
			node.score = score;
			node.cost = cost;
			node.parent = parent;
			
			mapModel.setNode(p,node);
			
			this.heapOpenList.push(node);
		}
		
		//分值排序方法
		private function sortMetord(n1:TraversalNote,n2:TraversalNote):Boolean
		{
			return n1.score < n2.score;
		}
	}
}