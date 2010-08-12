package ghostcat.algorithm.maze
{
	import ghostcat.algorithm.traversal.Traversal;
	import ghostcat.algorithm.traversal.TraversalNote;
	import ghostcat.util.RandomUtil;
	
	/**
	 * 随机迷宫创建器 
	 * @author flashyiyi
	 * 
	 */
	public class MazeCreater extends Traversal
	{
		private var result:Array;
		
		/**
		 * 结果阻碍对象数组 
		 * @return 
		 * 
		 */
		public function get blockMap():Array
		{
			return result;
		}
		
		/**
		 * 结果布尔数组 
		 * @return 
		 * 
		 */
		public function get boolMap():Array
		{
			return BlockUtil.blockToBoolMap(result);
		}
		
		public function MazeCreater(width:int,height:int)
		{
			//创建空迷宫数据，唯一的限制是不能重复行走，随机的方向选择就会创建出随机迷宫
			var mapModel:BlockModel = new BlockModel(BlockUtil.createBlockMap(width,height,true));
			this.result = BlockUtil.createBlockMap(width,height,true);
			super(mapModel);
		}
		
		public override function find(start:*, end:*) : Array
		{
			this.openList = [];
			
			mapModel.reset();
			var curTry : int = 0;
			
			this.openNote(start, 0, 0, null);//建立首节点
			
			while (this.openList.length > 0)
			{
				var cur:TraversalNote = this.openList.pop();;
				//获得最前的节点，并将它加入关闭列表
				this.closeNote(cur);
				
				var curPoint : * = cur.point;
				
				var aroundNotes : Array = mapModel.getArounds(cur.point);
				RandomUtil.randomArray(aroundNotes);
				
				for each (var p : * in aroundNotes)
				{
					var n:TraversalNote = mapModel.getNode(p);
					if (n && (n.noteClosed))//在关闭列表中则跳过
						continue;
					
					//否则加入开放列表 
					this.openNote(p, 0, 0, cur);
				}
			}
			return null;
		}
		
		/**
		 * 一边遍历一遍修改源地图造墙
		 */
		protected override function openNote(p:*, score:int, cost:int, parent:TraversalNote) : void
		{
			super.openNote(p,score,cost,parent);
			
			var block:Block4 = result[p.y][p.x];
			block.left = block.right = block.top = block.bottom = true;
			if (parent)
			{
				var pBlock:Block4 = result[parent.point.y][parent.point.x];
					
				if (p.x == parent.point.x - 1)
				{
					pBlock.left = false;
					block.right = false;
				}	
				if (p.x == parent.point.x + 1)
				{
					pBlock.right = false;
					block.left = false;
				}		
				if (p.y == parent.point.y - 1)
				{
					pBlock.top = false;
					block.bottom = false;
				}
				if (p.y == parent.point.y + 1)
				{
					pBlock.bottom = false;
					block.top = false;
				}
			}
		}
	}
}