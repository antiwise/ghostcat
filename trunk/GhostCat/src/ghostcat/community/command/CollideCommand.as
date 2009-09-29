package ghostcat.community.command
{
	import flash.display.DisplayObject;
	
	import ghostcat.display.GBase;
	import ghostcat.display.viewport.ICollisionClient;
	import ghostcat.events.CollideEvent;
	import ghostcat.util.Util;

	/**
	 * 碰撞检测（针对实现了ICollisionClient的对象）
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class CollideCommand
	{
		/**
		 * 检测碰撞并向目标发送碰撞事件
		 * 
		 * @param v1
		 * @param v2
		 * 
		 */
		private function COLLIDE(v1:DisplayObject,v2:DisplayObject):Boolean
		{
			if (v1 is GBase && v1 is ICollisionClient)
			{
				var g1:ICollisionClient = v1 as ICollisionClient;
				var g2:ICollisionClient = v2 as ICollisionClient;
				if (g1.collision.hitTestObject(g2.collision))
				{
					g1.dispatchEvent(Util.createObject(new CollideEvent(CollideEvent.COLLIDE),{vergePosition:g1.collision.lastVergePoint,hitObject:g2}));
					return true;
				}
			}
			else
			{
				if (v1.hitTestObject(v2))
				{
					v1.dispatchEvent(Util.createObject(new CollideEvent(CollideEvent.COLLIDE),{hitObject:v2}));
					return true;
				}
			}
			return false;
		}
	}
}