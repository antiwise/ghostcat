package ghostcat.community
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import ghostcat.events.MoveEvent;
	import ghostcat.util.display.DisplayUtil;

	/**
	 * 针对GBase对象的群聚基类
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GBaseCommunityManager extends CommunityManager
	{
		public function GBaseCommunityManager(command:Function)
		{
			super(command);
			
			this.setDirtyWhenEvent = MoveEvent.MOVE;//当发布MOVE事件的时候自动setDirty
		}
	}
}