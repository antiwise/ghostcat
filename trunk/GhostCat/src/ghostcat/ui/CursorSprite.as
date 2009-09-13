package ghostcat.ui
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import ghostcat.display.DisplayUtil;
	import ghostcat.display.GBase;
	import ghostcat.display.ICursorManagerClient;
	import ghostcat.util.ClassFactory;
	import ghostcat.util.Util;

	/**
	 * 光标类，需要手动加载到某个容器内，将一直处于最高层。
	 * 此类会一直检测鼠标下的物体，实现ICursorManagerClient就会根据其toolTipObj自动弹出。
	 * 
	 */		
		
	public class CursorSprite extends GBase
	{
		[Embed(skinClass="ghostcat.skin.cursor.CursorGroup")]
		private static const CursorGroupClass:Class;//这里不直接导入CursorGroup而用Embed中转只是为了正常生成ASDoc
		
		public static var defaultSkin:ClassFactory = new ClassFactory(CursorGroupClass);
		
		/*系统自带的默认Cursor定义*/
		public static const CURSOR_ARROW:String = "arrow";
        public static const CURSOR_BUSY:String = "busy";
        public static const CURSOR_POINT:String = "point";
        public static const CURSOR_DRAG:String = "drag";
		public static const CURSOR_H_DRAG:String = "hDrag";
		public static const CURSOR_V_DRAG:String = "vDrag";
		public static const CURSOR_ROTATE_TOPLEFT:String = "rotateTopLeft";
		public static const CURSOR_ROTATE_TOPRIGHT:String = "rotateTopRight";
		public static const CURSOR_ROTATE_BOTTOMLEFT:String = "rotateBottomLeft";
		public static const CURSOR_ROTATE_BOTTOMRIGHT:String = "rotateBottomRight";
		
		/**
		 *	光标集合，可自行添加内容。键为光标名，值为类
		 */		
		public var cursors:Object;
		
		/**
		 * 限定触发提示的类型
		 */
		public var onlyWithClasses:Array;
		
		/**
		 * 默认光标
		 */
		public var defaultCursor:DisplayObject = null;
		
		private var curCursor:*;//当前光标类型 
		
		private var target:DisplayObject;//当前鼠标下的对象
		
		private var buttonDown:Boolean=false;//鼠标是否按下 
		
		private var findCursor:Boolean=false;//是否自动查找鼠标
		
		private static var _instance:CursorSprite;
		
		/**
		 * 
		 * @param skin	皮肤动画，内部是数个默认光标的实例，以实例名为准
		 * 
		 */		
		public function CursorSprite(skin:DisplayObjectContainer=null)
		{
			super(null);
			
			if (!skin)
				skin = defaultSkin.newInstance();
			
			this.acceptContentPosition = false;
			
			if (!_instance)
				_instance = this;
			
			DisplayUtil.setMouseEnabled(this,false);
			
			
			cursors = new Object();
			for (var i:int;i < skin.numChildren;i++)
			{
				var child:DisplayObject = skin.getChildAt(i);
				cursors[child.name] = getDefinitionByName(getQualifiedClassName(child)) as Class;
			}
		}
		
		protected override function init():void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,this.updateButtonDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP,this.updateButtonDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
			stage.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
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
			findCursor = false;
			this.setCurrentCursorClass(c);
		}
		/**
		 * 移除光标，恢复自动获取模式
		 */		
		public function removeCursor():void
		{
			findCursor = true;
		}
		
		private function mouseMoveHandler(evt:MouseEvent):void
		{
			if (content)
			{
				this.x = parent.mouseX;
				this.y = parent.mouseY;
			}
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
			DisplayUtil.moveToHigh(this);
			
			if (findCursor)
				setCurrentCursorClass(findCursorClass(this.target));
			
			if (content){
				if (this.content is MovieClip){
					var mc:MovieClip = this.content as MovieClip;
					if (this.buttonDown)
						mc.nextFrame();
					else
						mc.prevFrame();
				}
			}
			
		}
		
		private function mouseLeaveHandler(evt:Event):void
		{
			if (findCursor)
				setContent(null);
		}
		
		private function setCurrentCursorClass(cursor:*):void
		{
			if (this.curCursor == cursor)
				return;
			
			this.curCursor = cursor;
			
			var obj:* = cursor;
			if (obj is String)
				obj = cursors[cursor];
			
			if (obj is Class)
				obj = new obj();
			
			if (!obj)
				obj = defaultCursor;
			
			if (obj)
			{
				setContent(obj);
				Mouse.hide();
				
				this.x = parent.mouseX;
				this.y = parent.mouseY;
			}
			else
			{
				setContent(null);
				Mouse.show();
			}
			
		}
		
		private function findCursorClass(displayObj : DisplayObject):*
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
		
		public override function destory():void
		{
			if (stage){
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
				stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.updateButtonDownHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP,this.updateButtonDownHandler);
				stage.removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
				stage.removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
				stage.removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
				stage.removeEventListener(Event.MOUSE_LEAVE,this.mouseLeaveHandler);
			}
		
			super.destory();
		} 
	}
}