package ghostcat.ui.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	import ghostcat.display.GBase;
	import ghostcat.events.ResizeEvent;
	import ghostcat.util.Util;
	
	public class Layout
	{
		private var _target:DisplayObjectContainer;
		
		public var children:Array = [];
		
		public function Layout(target:DisplayObjectContainer,isRoot:Boolean = false):void
		{
			setTarget(target,isRoot);
		}
		
		public function get target():DisplayObjectContainer
		{
			return _target;
		}
		
		public function setTarget(value:DisplayObjectContainer,isRoot:Boolean = false):void
		{
			if (_target)
			{
				_target.removeEventListener(ResizeEvent.RESIZE,resizeHandler);
				if (_target.stage)
					_target.stage.removeEventListener(Event.RESIZE,stageResizeHandler);
			}
			
			_target = value;
			
			if (_target)
			{
				if (isRoot)
				{
					if (_target.stage)
						_target.stage.addEventListener(Event.RESIZE,stageResizeHandler);
				}
				else
					_target.addEventListener(ResizeEvent.RESIZE,resizeHandler);
			}
		}
		
		public function addChild(child:DisplayObject):void
		{
			if (child.parent && child.parent == _target)
				return;
			
			_target.addChild(child);
			if (children.indexOf(child) == -1)
				children.push(child);
		}
		
		public function addChildAt(child:DisplayObject,index:int):void
		{
			if (child.parent && child.parent == _target)
				return;
			
			_target.addChildAt(child,index)
			if (children.indexOf(child) == -1)
				children.splice(index,0,child);
		}
		
		public function addAllChild():void
		{
			for (var i:int = 0;i < _target.numChildren;i++)
				addChild(_target.getChildAt(i));
		}
		
		public function removeChild(child:DisplayObject):void
		{
			_target.removeChild(child);
			Util.remove(children,child);
		}
		
		public function removeAllChild():void
		{
			if (!_target)
				return;
			
			for (var i:int = children.length - 1;i >= 0;i--)
				removeChild(_target.getChildAt(i))
				
			children = [];
		}
		
		public function destory():void
		{
			removeAllChild();
			
			setTarget(null);
		}
		
		protected function resizeHandler(event:ResizeEvent):void
		{
			var rect:Rectangle = _target.getRect(_target);
			layoutChildren(rect.x,rect.y,rect.width,rect.height);
		}
		
		protected function stageResizeHandler(event:Event):void
		{
			var stage:Stage = target as Stage;
			layoutChildren(0,0,stage.stageWidth,stage.stageHeight);
		}
		
		
		/**
		 * 根据Children决定自身体积
		 * 
		 */
		protected function measureChildren():void
		{
		}
		
		/**
		 * 对Chilren布局
		 * 
		 * @param x
		 * @param y
		 * @param w
		 * @param h
		 * 
		 */
		protected function layoutChildren(x:Number,y:Number,w:Number, h:Number):void
		{
		}
	}
	
}
