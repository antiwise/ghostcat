package ghostcat.ui.layout
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import ghostcat.events.ResizeEvent;
	import ghostcat.util.core.AbstractUtil;
	import ghostcat.util.core.CallLater;
	import ghostcat.util.display.Geom;
	
	/**
	 * 布局器基类，此类为抽像类
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class Layout
	{
		private var _target:DisplayObjectContainer;
		
		/**
		 * 是否以舞台的边框作为范围 
		 */
		public var isRoot:Boolean;
		
		/**
		 * 
		 * @param target	容器
		 * @param isRoot	是否以舞台的边框作为范围
		 * 
		 */
		public function Layout(target:DisplayObjectContainer,isRoot:Boolean = false):void
		{
			AbstractUtil.preventConstructor(this,Layout);
			setTarget(target,isRoot);
		}
		
		/**
		 * 容器
		 * @return 
		 * 
		 */
		public function get target():DisplayObjectContainer
		{
			return _target;
		}
		
		/**
		 * 设置容器 
		 * @param value
		 * @param isRoot	是否按舞台处理
		 * 
		 */
		public function setTarget(value:DisplayObjectContainer,isRoot:Boolean = false):void
		{
			if (_target)
			{
				_target.removeEventListener(ResizeEvent.RESIZE,resizeHandler);
				_target.removeEventListener(ResizeEvent.CHILD_RESIZE,resizeHandler);
				if (_target.stage)
					_target.stage.removeEventListener(Event.RESIZE,resizeHandler);
			}
			
			_target = value;
			this.isRoot = isRoot;
			
			if (_target)
			{
				_target.addEventListener(ResizeEvent.CHILD_RESIZE,resizeHandler);
				if (isRoot)
				{
					if (_target.stage)
						_target.stage.addEventListener(Event.RESIZE,resizeHandler);
				}
				else
					_target.addEventListener(ResizeEvent.RESIZE,resizeHandler);
			}
			
		}
		
		/**
		 * 销毁
		 * 
		 */
		public function destory():void
		{
			setTarget(null);
		}
		
		private function resizeHandler(event:Event):void
		{
			invalidateLayout();
		}
		
		/**
		 * 在一次更新布局 
		 * 
		 */
		public function invalidateLayout():void
		{
			CallLater.callLater(vaildLayout,null,true);
		}
		
		/**
		 * 更新布局
		 * 
		 */
		public function vaildLayout():void
		{
			var rect:Rectangle;
			if (isRoot)
			{
				var stage:Stage = target.stage;
				rect = Geom.localRectToContent(new Rectangle(0,0,stage.stageWidth,stage.stageHeight),stage,_target);
			}
			else
			{
				rect = _target.getRect(_target);
			}
			layoutChildren(rect.x,rect.y,rect.width,rect.height);
		}
		
		
//		/**
//		 * 根据Children决定自身体积
//		 * 
//		 */
//		protected function measureChildren():void
//		{
//		}
		
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
