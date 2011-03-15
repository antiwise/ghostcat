package ghostcat.game.layer.collision
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import ghostcat.game.item.collision.ICollision;
	import ghostcat.game.layer.GameLayerBase;
	
	public class CollisionManager implements ICollisionManager
	{
		public var layer:GameLayerBase;
		/**
		 * 检测字段 
		 */
		public var field:String = "collision";
		/**
		 * 是否限定在屏幕内
		 */
		public var limitInScreen:Boolean;
		public var collisions:Array = [];
		public function CollisionManager(layer:GameLayerBase,field:String = "collision",limitInScreen:Boolean = false)
		{
			this.layer = layer;
			this.field = field;
			this.limitInScreen = limitInScreen;
		}
		
		public function collideAll():void
		{
			this.collisions = [];
			
			var list:Array = limitInScreen ? layer.childrenInScreen : layer.children;
			var l:int = list.length;
			for (var i:int = 0;i < l - 1;i++)
			{
				var o1:Object = list[i];
				var c1:ICollision = o1.hasOwnProperty(field) ? o1[field] : null;
				if (c1)
				{
					for (var j:int = i + 1;j < l;j++)
					{
						var o2:Object = list[j];
						var c2:ICollision = o2.hasOwnProperty(field) ? o2[field] : null;
						if (c2)
						{
							if (c1.hitTest(c2))
							{
								this.collisions[this.collisions.length] = [c1,c2];
							}
						}
					}
				}
			}
		}
	}
}