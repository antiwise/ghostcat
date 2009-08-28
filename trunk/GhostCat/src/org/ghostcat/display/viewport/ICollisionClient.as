package org.ghostcat.display.viewport
{
	import flash.events.IEventDispatcher;

	/**
	 * 支持不规则碰撞的物品需要实现的接口
	 * 
	 * @author flashyiyi
	 * 
	 */
	public interface ICollisionClient extends IEventDispatcher
	{
		function get collision():Collision;
	}
}