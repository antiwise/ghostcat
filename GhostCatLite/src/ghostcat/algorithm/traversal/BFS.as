package ghostcat.algorithm.traversal
{
	/**
	 * 广度优先遍历 
	 * @author flashyiyi
	 * 
	 */
	public class BFS extends Traversal
	{
		public function BFS(mapModel:MapModel, maxTry:int=5000)
		{
			super(mapModel, maxTry);
		}
		
		/**
		 * 计算两个坐标之间的路径
		 * 
		 * @param startP	开始坐标
		 * @param endP	结束坐标
		 * @return	一个数组，为中间步骤的坐标 
		 * 
		 */
		public override function find(start:*, end:*) : Array
		{
			this.openList = [];
			
			mapModel.reset();
			var curTry : int = 0;
			
			this.openNote(start, 0, 0, null);//建立首节点
			
			while (this.openList.length > 0)
			{
				if (++curTry > this.maxTry)
					return null;
				
				var cur:TraversalNote = this.openList.shift();
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
					//计算路程消耗，便于选择最短路径
					var cost : int = cur.cost + mapModel.getCostAddon(start,cur.point,p,end);
					if (n && n.noteClosed)//在关闭列表中则跳过
						continue;
					
					if (n && n.noteOpen)
					{
						//如果新的消耗比节点原来的消耗小,修改消耗值
						if (cost < n.cost)
						{
							n.cost = cost;
							n.parent = cur;
						}	
					}
					else
					//否则加入开放列表 
						this.openNote(p, 0, cost, cur);
				}
			}
			return null;
		}
	}
}