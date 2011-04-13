package ghostcat.display
{
	import flash.display.DisplayObject;
	
	import ghostcat.events.TickEvent;

	/**
	 * 提供将Tick事件向子对象传递的功能，这种方法比独自建立监听更快
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GTickBase extends GBase
	{
		/**
		 * 子对象数组 
		 */
		public var children:Array = [];
		public function GTickBase(skin:*=null, replace:Boolean=true)
		{
			super(skin, replace);
		}
		
		/** @inheritDoc*/
		public override function addChild(child:DisplayObject) : DisplayObject
		{
			children.push(child);
			return super.addChild(child);
		}
		
		/** @inheritDoc*/
		public override function addChildAt(child:DisplayObject,index:int) : DisplayObject
		{
			children.splice(index,0,child);
			return super.addChildAt(child,index);
		}
		
		/** @inheritDoc*/
		public override function removeChild(child:DisplayObject) : DisplayObject
		{
			children.splice(children.indexOf(child),1);
			return super.removeChild(child);
		}
		
		/** @inheritDoc*/
		public override function removeChildAt(index:int) : DisplayObject
		{
			children.splice(index,1);
			return super.removeChild(children[index]);
		}
		
		/** @inheritDoc*/
		protected override function tickHandler(event:TickEvent) : void
		{
			if (!paused)
				return;
				
			super.tickHandler(event);
			
			for each (var child:DisplayObject in children)
			{
				if (child is GBase)
					(child as GBase).tick(event.interval);
			}
		}
	}
}