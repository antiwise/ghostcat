package org.ghostcat.ui
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Mouse;
	
	import org.ghostcat.display.ICursorManagerClient;
	import org.ghostcat.display.movieclip.GMovieClip;
	import org.ghostcat.util.DisplayUtil;
	import org.ghostcat.util.Util;

	/**
	 * 光标类，需要手动加载到某个容器内，将一直处于最高层。
	 * 此类会一直检测鼠标下的物体，当其拥有toolTip属性时（无论是否继承GRepeater），就会根据其toolTipObj自动弹出。
	 * 
	 */		
		
	public class CursorSprite extends GMovieClip
	{
		/**
		 *	光标集合，可自行添加内容 
		 */		
		public var cursors:Object;
		
		/**
		 *  限定触发提示的类型
		 */
		public var onlyWithClasses:Array;
		
		private var curCursor:*;//当前光标类型 
		
		private var target:DisplayObject;//当前鼠标下的对象
		
		private var buttonDown:Boolean=false;//鼠标是否按下 
		
		private static var _instance:CursorSprite;
		/**
		 * 
		 * @param skin	皮肤动画，内部是数个默认光标，以实例名为准
		 * 
		 */		
		public function CursorSprite(skin:DisplayObjectContainer)
		{
			super(null);
			
			this.acceptContentPosition = false;
			
			if (!_instance)
				_instance = this;
			
			DisplayUtil.setMouseEnabled(this,false);
			
			
			cursors = new Object();
			for (var i:int;i < skin.numChildren;i++)
			{
				var child:DisplayObject = skin.getChildAt(i);
				cursors[child.name] = child;
			}
		}
		
		protected override function init():void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE,this.updateButtonDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,this.updateButtonDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP,this.updateButtonDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
			stage.addEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
			stage.addEventListener(Event.MOUSE_LEAVE,this.mouseLeaveHandler);
		}
		
		public static function get instance():CursorSprite
		{
			return _instance;
		}
		/**
		 * 手动设置光标。此光标将一直存在直到执行removeCursor
		 */		
		public function setCursor(c:*):void
		{
			stage.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
			this.setCurrentCursorClass(c);
		}
		/**
		 * 移除光标，恢复自动获取模式
		 */		
		public function removeCursor():void
		{
			stage.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		
		private function mouseOverHandler(evt:MouseEvent):void
		{
			var t:DisplayObject = evt.target as DisplayObject;
			this.target = t;
			buttonDown = evt.buttonDown;
		}
		
		private function updateButtonDownHandler(evt:MouseEvent):void
		{
			buttonDown = evt.buttonDown;
		}
		
		private function enterFrameHandler(evt:Event):void
		{
			DisplayUtil.moveToHigh(this);
			
			setCurrentCursorClass(findCursorClass(this.target));
			
			if (content){
				this.x = parent.mouseX;
				this.y = parent.mouseY;
				if (this.content is MovieClip){
					if (this.buttonDown){
						this.mc.nextFrame();
					}else{
						this.mc.prevFrame();
					}
				}
			}
			
		}
		
		private function mouseLeaveHandler(evt:Event):void
		{
			setContent(null);
		}
		
		private function setCurrentCursorClass(cursor:*):void
		{
			if (this.curCursor == cursor)
				return;
			
			this.curCursor = cursor;
			
			var classRef:Class;
			if (cursor is Class)
			{
				classRef = cursor;
			}else{
				classRef = cursors[cursor.toString()]
			}
			
			if(classRef)
			{
				setContent(new classRef());
				Mouse.hide();
			}else
			{
				setContent(null);
				Mouse.show();
			}
			
		}
		
		private function findCursorClass(displayObj : DisplayObject):Class
		{
			var currentCursorTarget:DisplayObject = displayObj;
			
			while (currentCursorTarget && currentCursorTarget.parent!=currentCursorTarget)
			{
				if(currentCursorTarget is TextField && TextField(currentCursorTarget).selectable)
					return null;
				
				if(currentCursorTarget is Sprite && Sprite(currentCursorTarget).buttonMode == true)
					return null;
				
				if(currentCursorTarget is ICursorManagerClient)
				{
					var cursor:Class = (currentCursorTarget as ICursorManagerClient).cursor;
					if (cursor && (onlyWithClasses == null || Util.isIn(cursor,onlyWithClasses)))
						return cursor;
				}
				currentCursorTarget = currentCursorTarget.parent;
			}
			return null;
		}
		
		public override function destory():void
		{
			super.destory();
			
			if (stage){
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.updateButtonDownHandler);
				stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.updateButtonDownHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP,this.updateButtonDownHandler);
				stage.removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
				stage.removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
				stage.removeEventListener(Event.MOUSE_LEAVE,this.mouseLeaveHandler);
			}
		} 
	}
}