package ghostcat.game.layer.collision
{
	import flash.geom.Point;
	
	import ghostcat.algorithm.traversal.AStar;
	import ghostcat.algorithm.traversal.MapModel;
	import ghostcat.game.layer.GameLayer;
	import ghostcat.game.util.GameMoveByPathOper;

	/**
	 * 障碍格子碰撞
	 * @author Administrator
	 * 
	 */
	public class BlockCollisionManager implements ICollisionManager
	{
		public var layer:GameLayer;
		public var blockMap:MapModel;
		public var astar:AStar;
		public var result:Array = [];
		public var collisionList:Array;
		public var enabled:Boolean;
		public function BlockCollisionManager(layer:GameLayer,blockMap:MapModel)
		{
			this.layer = layer;
			this.blockMap = blockMap;
			this.astar = new AStar(blockMap);
		}
		
		/**
		 * 寻路 
		 * @param start
		 * @param end
		 * @return 
		 * 
		 */
		public function getPath(start:Point, end:Point):Array
		{
			return this.astar.find(start,end);
		}
		
		public function collideAll():void
		{
			if (!enabled)
				return;
				
			this.result = [];
			
			var list:Array = collisionList ? collisionList : layer.children;
			var l:int = list.length;
			for (var i:int = 0;i < l - 1;i++)
			{
				var o:Object = list[i];
				var p:Point = new Point(int(o.x),int(o.y));
				if (blockMap.isBlock(p,null))
					this.result[this.result.length] = [o,p];
			}
		}
	}
}