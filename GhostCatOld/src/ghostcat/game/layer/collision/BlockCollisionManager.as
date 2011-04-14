package ghostcat.game.layer.collision
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import ghostcat.algorithm.traversal.AStar;
	import ghostcat.algorithm.traversal.IMapModel;
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
		public var blockMap:IMapModel;
		public var astar:AStar;
		public var result:Array = [];
		public var collisionList:Array;
		public var enabled:Boolean;
		public function BlockCollisionManager(layer:GameLayer,blockMap:IMapModel)
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
		
		/**
		 * 移动物体到目标点 
		 * @param item	对象
		 * @param end	目标（网格坐标）
		 * @param speed	速度
		 * @return 返回控制移动的GameMoveByPathOper对象
		 * 
		 */
		public function moveItemToPoint(item:DisplayObject,end:Point,speed:Number = 100):GameMoveByPathOper
		{
			var start:Point = layer.getObjectPosition(item);
			var path:Array = getPath(new Point(Math.floor(start.x),Math.floor(start.y)),new Point(Math.floor(end.x),Math.floor(end.y)));
			
			if (path)
			{
				path[0] = start;
				var oper:GameMoveByPathOper = new GameMoveByPathOper(path,speed,item,this.layer);
				oper.execute();
				
				return oper;
			}
			return null;
		}
		
		/**
		 * 是否阻碍 
		 * @param p
		 * @return 
		 * 
		 */
		public function isBlock(p:Point):Boolean
		{
			return this.blockMap.isBlock(p)
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
				if (blockMap.isBlock(p))
					this.result[this.result.length] = [o,p];
			}
		}
	}
}