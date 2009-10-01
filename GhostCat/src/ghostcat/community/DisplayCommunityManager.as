package ghostcat.community
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import ghostcat.events.MoveEvent;
	import ghostcat.util.display.DisplayUtil;

	/**
	 * 针对显示对象的群聚基类
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class DisplayCommunityManager extends CommunityManager
	{
		public function DisplayCommunityManager(command:Function)
		{
			super(command);
			
			this.setDirtyWhenEvent = MoveEvent.MOVE;//当发布MOVE事件的时候自动setDirty
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