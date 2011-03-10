package ghostcat.ui
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import ghostcat.display.GBase;
	import ghostcat.display.ICursorManagerClient;
	import ghostcat.skin.cursor.CursorGroup;
	import ghostcat.util.Util;
	import ghostcat.util.core.ClassFactory;
	import ghostcat.util.display.DisplayUtil;
	
	/**
	 * 原生光标类
	 * 此类会一直检测鼠标下的物体，实现ICursorManagerClient就会根据其cursor自动弹出。
	 * 
	 */		
	
	public class NativeCursor extends EventDispatcher
	{
		/**
		 * 限定触发提示的类型
		 */
		public var onlyWithClasses:Array;
		
		/**
		 * 舞台
		 */
		public var stage:Stage;
		
		/**
		 * 默认光标
		 */
		public var defaultCursor:String;
		
		private var curCursor:String;//当前光标类型 
		
		private var target:DisplayObject;//当前鼠标下的对象
		
		private var buttonDown:Boolean=false;//鼠标是否按下 
		
		private var _lock:Boolean=false;//锁定鼠标
		
		private static var _instance:NativeCursor;
		
		public function NativeCursor(stage:Stage)
		{
			this.stage = stage;
			_instance = this;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,this.updateButtonDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP,this.updateButtonDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
			stage.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
			stage.addEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
		}
		
		public static function get instance():NativeCursor
		{
			return _instance;
		}
		
		/**
		 * 手动设置光标。此光标将一直存在直到执行removeCursor
		 */		
		public function setCursor(c:String):void
		{
			_lock = true;
			this.setCurrentCursorClass(c);
		}
		/**
		 * 移除光标，恢复自动获取模式
		 */		
		public function removeCursor():void
		{
			_lock = false;
		}
		
		/**
		 * 锁定光标 
		 * @return 
		 * 
		 */
		public function get lock():Boolean
		{
			return _lock;
		}
		
		public function set lock(value:Boolean):void
		{
			_lock = value;
		}
		
		
		private function mouseMoveHandler(evt:MouseEvent):void
		{
			updateButtonDownHandler(evt);
		}
		
		private function mouseOverHandler(evt:MouseEvent):void
		{
			this.target = evt.target as DisplayObject;
			updateButtonDownHandler(evt);
		}
		
		private function mouseOutHandler(evt:MouseEvent):void
		{
			this.target = null;
			updateButtonDownHandler(evt);
		}
		
		private function updateButtonDownHandler(evt:MouseEvent):void
		{
			buttonDown = evt.buttonDown;
		}
		
		private function enterFrameHandler(evt:Event):void
		{
			if (!_lock)
				setCurrentCursorClass(findCursorClass(this.target));
		}
		
		private function setCurrentCursorClass(cursor:String):void
		{
			if (this.curCursor == cursor)
				return;
			
			this.curCursor = cursor;
			
			Mouse.cursor = cursor ? cursor : defaultCursor;
		}
		
		private function findCursorClass(displayObj : DisplayObject):String
		{
			var currentCursorTarget:DisplayObject = displayObj;
			
			while (currentCursorTarget && currentCursorTarget.parent!=currentCursorTarget)
			{
				//可编辑的文本需要显示编辑框，必须显示设备光标
				if(currentCursorTarget is TextField && TextField(currentCursorTarget).selectable)
					return null;
				
				//拥有buttonMode的需要显示手型
				if(currentCursorTarget is Sprite && Sprite(currentCursorTarget).buttonMode == true)
					return null;
				
				if(currentCursorTarget is ICursorManagerClient)
				{
					var cursor:* = (currentCursorTarget as ICursorManagerClient).cursor;
					if (cursor && (onlyWithClasses == null || Util.isIn(currentCursorTarget,onlyWithClasses)))
						return cursor;
				}
				currentCursorTarget = currentCursorTarget.parent;
			}
			return null;
		}
		/** @inheritDoc*/
		public function destory():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.updateButtonDownHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP,this.updateButtonDownHandler);
			stage.removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
			stage.removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
			stage.removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
		} 
	}
}