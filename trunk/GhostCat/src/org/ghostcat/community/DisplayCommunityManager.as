package org.ghostcat.community
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import org.ghostcat.events.MoveEvent;
	import org.ghostcat.util.DisplayUtil;

	/**
	 * 针对显示对象的数据集群基类
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class DisplayCommunityManager extends CommunityManager
	{
		public function DisplayCommunityManager(command:Function)
		{
			super(command);
			
			this.setDirtyWhenEvent = MoveEvent.MOVE;
		}
		
		/**
		 * 添加一个显示对象的所有子对象
		 * 
		 * @param target
		 * 
		 */
		public function addAllChildren(target:DisplayObjectContainer):void
		{
			for (var i:int = 0;i < target.numChildren;i++)
				add(target.getChildAt(i));
		}
		
		/**
		 * 删除一个显示对象的所有子对象
		 * 
		 * @param target
		 * 
		 */
		public function removeAllChildren(target:DisplayObjectContainer):void
		{
			for (var i:int = 0;i < target.numChildren;i++)
				remove(target.getChildAt(i));
		}
	}
}