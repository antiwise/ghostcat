package ghostcat.community
{
	import flash.events.EventDispatcher;
	
	import ghostcat.display.IGBase;
	import ghostcat.events.MoveEvent;

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
		/** @inheritDoc*/
		public override function add(obj:*,checkDup:Boolean = true):void
		{
			if (!(obj is IGBase))
				return;
			
			super.add(obj,checkDup);
			
			setDirty(obj);//加入时立即计算
		}
		/** @inheritDoc*/
		public override function calculateAll(onlyFilter:Boolean = true):void
		{
			super.calculateAll(onlyFilter);
			
		}
	}
}