package ghostcat.display.particle
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import ghostcat.events.TickEvent;
	import ghostcat.util.Tick;
	import ghostcat.util.core.AbstractUtil;
	
	/**
	 * 粒子生成器基类
	 * @author flashyiyi
	 * 
	 */
	public class ParticleCreaterBase extends Sprite
	{
		public var contentWidth:Number;
		public var contentHeight:Number;
		
		public var children:Array;
		public var childrenCache:Array;
		public function ParticleCreaterBase(contentWidth:Number,contentHeight:Number)
		{
			super();
			
			AbstractUtil.preventConstructor(this,ParticleCreaterBase)
			
			this.contentWidth = contentWidth;
			this.contentHeight = contentHeight;
			this.scrollRect = new Rectangle(0,0,contentWidth,contentHeight);
			
			this.children = [];
			this.childrenCache = [];
			
			Tick.instance.addEventListener(TickEvent.TICK,tickHandler);
		}
		
		private function tickHandler(event:TickEvent):void
		{
			tick(event.interval);
		}
		
		public function tick(interval:int):void
		{
			//
		}
		
		protected function createNewChild():DisplayObject
		{
			return null;
		}
		
		protected function placeNewChild(child:DisplayObject):void
		{
			//
		}
		
		protected function destoryChild(child:DisplayObject):void
		{
			//
		}
		
		public function add():void
		{
			var child:DisplayObject;
			if (childrenCache.length)
				child = childrenCache.pop();
			else
				child = createNewChild();
			
			children.push(child);
			addChild(child);
			
			this.placeNewChild(child);
		}
		
		public function remove(child:DisplayObject):void
		{
			removeChild(child);
			
			var index:int = children.indexOf(child);
			if (index!=-1)
				children.splice(index, 1);
			
			childrenCache.push(child);
		}
		
		public function destory():void
		{
			for each (var child:DisplayObject in children)
				destoryChild(child);
				
			for each (child in childrenCache)
				destoryChild(child);
			
			Tick.instance.removeEventListener(TickEvent.TICK,tickHandler);
			if (parent)
				parent.removeChild(this);
		}
	}
}