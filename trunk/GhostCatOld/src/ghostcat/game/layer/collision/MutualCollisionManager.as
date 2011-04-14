package ghostcat.game.layer.collision
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import ghostcat.game.item.collision.ICollision;
	import ghostcat.game.layer.collision.client.ICollisionClient;
	import ghostcat.game.layer.GameLayer;
	
	/**
	 * 物体间碰撞 
	 * @author flashyiyi
	 * 
	 */
	public class MutualCollisionManager implements ICollisionManager
	{
		public var layer:GameLayer;
		
		public var result:Array = [];
		public var collisionList:Array;
		public function MutualCollisionManager(layer:GameLayer)
		{
			this.layer = layer;
		}
		
		public function collideAll():void
		{
			this.result = [];
			
			var list:Array = collisionList ? collisionList : layer.children;
			var l:int = list.length;
			for (var i:int = 0;i < l - 1;i++)
			{
				var o1:ICollisionClient = list[i] as ICollisionClient;
				var c1:ICollision = o1 ? o1.collision : null;
				if (c1)
				{
					for (var j:int = i + 1;j < l;j++)
					{
						var o2:ICollisionClient = list[j] as ICollisionClient;
						var c2:ICollision = o2 ? o2.collision : null;
						if (c2)
						{
							if (c1.hitTest(c2))
							{
								this.result[this.result.length] = [o1,o2];
							}
						}
					}
				}
			}
		}
	}
}