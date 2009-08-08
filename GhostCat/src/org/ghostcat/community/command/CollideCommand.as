package org.ghostcat.community.command
{
	import flash.display.DisplayObject;
	
	import org.ghostcat.display.GBase;
	import org.ghostcat.events.CollideEvent;
	import org.ghostcat.util.Util;

	/**
	 * 碰撞检测
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class CollideCommand
	{
		private function COLLIDE(v1:DisplayObject,v2:DisplayObject):void
		{
			if (v1 is GBase && v1 is GBase)
			{
				var g1:GBase = v1 as GBase;
				var g2:GBase = v2 as GBase;
				if (g1.collision.hitTestObject(g2.collision))
					g1.dispatchEvent(Util.createObject(new CollideEvent(CollideEvent.COLLIDE),{vergePosition:g1.collision.lastVergePoint,hitObject:g2}));
			}
			else
			{
				if (v1.hitTestObject(v2))
					v1.dispatchEvent(Util.createObject(new CollideEvent(CollideEvent.COLLIDE),{hitObject:v2}));
			}
		}
	}
}