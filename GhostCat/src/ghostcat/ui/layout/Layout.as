
package ghostcat.ui.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	
	public class Layout extends EventDispatcher
	{
		private var _target:DisplayObjectContainer;
		
		public function Layout(target:DisplayObjectContainer):void
		{
			this.target = target;
		}
		
		public function get target():DisplayObjectContainer
		{
			return _target;
		}
		
		public function set target(value:DisplayObjectContainer):void
		{
			_target = value;
		}
		
		public function addChild(child:DisplayObject):void
		{
			if (child.parent && child.parent == _target)
				return;
			
			_target.addChild(child);
		}
		
		public function addChildAt(child:DisplayObject,index:int):void
		{
			if (child.parent && child.parent == _target)
				return;
			
			_target.addChildAt(child,index)
		}
		
		public function addAllChild():void
		{
			for (var i:int = 0;i < _target.numChildren;i++)
				addChild(_target.getChildAt(i));
		}
		
		public function removeChild(child:DisplayObject):void
		{
			_target.removeChild(child);
		}
		
		public function removeAllChild():void
		{
			while (_target.numChildren)
				removeChild(_target.getChildAt(0))
		}
		
		public function measureChildren():void
		{
		}
		
		public function layoutChildren(x:Number,y:Number,w:Number, h:Number):void
		{
		}
	}
	
}
