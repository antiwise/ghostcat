package ghostcat.display.graphics
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import ghostcat.display.GBase;
	import ghostcat.events.MoveEvent;
	import ghostcat.parse.display.RectParse;
	import ghostcat.parse.graphics.GraphicsFill;
	import ghostcat.parse.graphics.GraphicsLineStyle;
	import ghostcat.parse.graphics.GraphicsRect;
	import ghostcat.ui.CursorSprite;

	/**
	 * 缩放盒子（不干涉原图元，但不支持旋转）
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ScaleBox extends GBase
	{
		private static var objs:Dictionary = new Dictionary();
		
		/**
		 * 注册 
		 * @param target
		 * 
		 */
		public static function register(target:DisplayObject):void
		{
			objs[target] = new ScaleBox(target);
		}
		
		/**
		 * 取消注册 
		 * @param target
		 * 
		 */
		public static function unregister(target:DisplayObject):void
		{
			objs[target].destory();
			delete objs[target];
		}
		
		public var fillControl:DragPoint;
		
		public var topLeftControl:DragPoint;
		public var topRightControl:DragPoint;
		public var bottomLeftControl:DragPoint;
		public var bottomRightControl:DragPoint;
		
		public var topLineControl:DragPoint;
		public var bottomLineControl:DragPoint;
		public var leftLineControl:DragPoint;
		public var rightLineControl:DragPoint;
		
		private var _lockMove:Boolean;
		
		/**
		 * 是否禁止移动 
		 * @return 
		 * 
		 */
		public function get lockMove():Boolean
		{
			return _lockMove;
		}
		
		public function set lockMove(value:Boolean):void
		{
			_lockMove = value;
			fillControl.visible = !value;
		}
		
		private var fill:GraphicsFill = new GraphicsFill(0,0);
		private var lineStyle:GraphicsLineStyle = new GraphicsLineStyle();
		
		public function ScaleBox(target:DisplayObject)
		{
			super();
			
			createControl();
			
			this.content = target;
			
			this.selected = true;
		}
		
		/** @inheritDoc*/
		public override function set selected(v:Boolean):void
		{
			super.selected = v;
			
			if (v)
			{
				content.parent.addChild(this);
				updateControls();
			}
			else
			{
				content.parent.removeChild(this);
			}
		}
			
		/**
		 * 更新控制点
		 * 
		 */
		public function updateControls():void
		{
			var rect:Rectangle = content.getBounds(content.parent);
			
			fillControl.setPosition(new Point(rect.x,rect.y),true);
			new RectParse(new GraphicsRect(2,2,rect.width - 4,rect.height - 4),lineStyle,fill,null,true).parse(fillControl.content);
			
			
			topLeftControl.setPosition(new Point(rect.x,rect.y),true);
			new RectParse(new GraphicsRect(-2,-2,4,4),lineStyle,fill,null,true).parse(topLeftControl.content);
			
			topRightControl.setPosition(new Point(rect.right,rect.y),true);
			new RectParse(new GraphicsRect(-2,-2,4,4),lineStyle,fill,null,true).parse(topRightControl.content);
			
			bottomLeftControl.setPosition(new Point(rect.x,rect.bottom),true);
			new RectParse(new GraphicsRect(-2,-2,4,4),lineStyle,fill,null,true).parse(bottomLeftControl.content);
			
			bottomRightControl.setPosition(new Point(rect.right,rect.bottom),true);
			new RectParse(new GraphicsRect(-2,-2,4,4),lineStyle,fill,null,true).parse(bottomRightControl.content);
			
			
			topLineControl.setPosition(new Point(rect.x,rect.y),true);
			new RectParse(new GraphicsRect(2,-2,rect.width-4,4),lineStyle,fill,null,true).parse(topLineControl.content);
			
			bottomLineControl.setPosition(new Point(rect.x,rect.bottom),true);
			new RectParse(new GraphicsRect(2,-2,rect.width-4,4),lineStyle,fill,null,true).parse(bottomLineControl.content);
			
			leftLineControl.setPosition(new Point(rect.x,rect.y),true);
			new RectParse(new GraphicsRect(-2,2,4,rect.height-4),lineStyle,fill,null,true).parse(leftLineControl.content);
			
			rightLineControl.setPosition(new Point(rect.right,rect.y),true);
			new RectParse(new GraphicsRect(-2,2,4,rect.height-4),lineStyle,fill,null,true).parse(rightLineControl.content);
		}
		
		private function createControl():void
		{
			fillControl = new DragPoint(new Shape());
			fillControl.cursor = CursorSprite.CURSOR_DRAG;
			fillControl.addEventListener(MoveEvent.MOVE,fillMouseDownHandler,false,0,true);
			addChild(fillControl);
			
			topLeftControl = new DragPoint(new Shape());	
			topLeftControl.cursor = CursorSprite.CURSOR_HV_DRAG;
			topLeftControl.addEventListener(MoveEvent.MOVE,topLeftControlHandler,false,0,true);
			addChild(topLeftControl);
			
			topRightControl = new DragPoint(new Shape());	
			topRightControl.cursor = CursorSprite.CURSOR_VH_DRAG;
			topRightControl.addEventListener(MoveEvent.MOVE,topRightControlHandler,false,0,true);
			addChild(topRightControl);
			
			bottomLeftControl = new DragPoint(new Shape());	
			bottomLeftControl.cursor = CursorSprite.CURSOR_VH_DRAG;
			bottomLeftControl.addEventListener(MoveEvent.MOVE,bottomLeftControlHandler,false,0,true);
			addChild(bottomLeftControl);
			
			bottomRightControl = new DragPoint(new Shape());	
			bottomRightControl.cursor = CursorSprite.CURSOR_HV_DRAG;
			bottomRightControl.addEventListener(MoveEvent.MOVE,bottomRightControlHandler,false,0,true);
			addChild(bottomRightControl);
			
			topLineControl = new DragPoint(new Shape());	
			topLineControl.cursor = CursorSprite.CURSOR_V_DRAG;
			topLineControl.lockX = true;
			topLineControl.addEventListener(MoveEvent.MOVE,topLineControlHandler,false,0,true);
			addChild(topLineControl);
			
			bottomLineControl = new DragPoint(new Shape());	
			bottomLineControl.cursor = CursorSprite.CURSOR_V_DRAG;
			bottomLineControl.lockX = true;
			bottomLineControl.addEventListener(MoveEvent.MOVE,bottomLineControlHandler,false,0,true);
			addChild(bottomLineControl);
			
			leftLineControl = new DragPoint(new Shape());	
			leftLineControl.cursor = CursorSprite.CURSOR_H_DRAG;
			leftLineControl.lockY = true;
			leftLineControl.addEventListener(MoveEvent.MOVE,leftLineControlHandler,false,0,true);
			addChild(leftLineControl);
			
			rightLineControl = new DragPoint(new Shape());	
			rightLineControl.cursor = CursorSprite.CURSOR_H_DRAG;
			rightLineControl.lockY = true;
			rightLineControl.addEventListener(MoveEvent.MOVE,rightLineControlHandler,false,0,true);
			addChild(rightLineControl);
		}
		
		private function topLineControlHandler(event:MoveEvent):void
		{
			if (!topLineControl.mouseDown)
				return;
			
			var rect:Rectangle = content.getBounds(content.parent);
			var dy:Number = topLineControl.position.y - rect.y;
			content.y += dy;
			content.height -= dy;
			
			updateControls();
		}
		
		private function bottomLineControlHandler(event:MoveEvent):void
		{
			if (!bottomLineControl.mouseDown)
				return;
			
			content.height = bottomLineControl.position.y - topLineControl.position.y;
			
			updateControls();
		}
		
		private function leftLineControlHandler(event:MoveEvent):void
		{
			if (!leftLineControl.mouseDown)
				return;
			
			var rect:Rectangle = content.getBounds(content.parent);
			var dx:Number = leftLineControl.position.x - rect.x;
			content.x += dx;
			content.width -= dx;
			
			updateControls();
		}
		
		private function rightLineControlHandler(event:MoveEvent):void
		{
			if (!rightLineControl.mouseDown)
				return;
			
			content.width = rightLineControl.position.x - leftLineControl.x;
			
			updateControls();
		}
		
		private function topLeftControlHandler(event:MoveEvent):void
		{
			if (!topLeftControl.mouseDown)
				return;
			
			var rect:Rectangle = content.getBounds(content.parent);
			var dx:Number = topLeftControl.position.x - rect.x;
			content.x += dx;
			content.width -= dx;
			var dy:Number = topLeftControl.position.y - rect.y;
			content.y += dy;
			content.height -= dy;
			
			updateControls();
		}
		
		private function topRightControlHandler(event:MoveEvent):void
		{
			if (!topRightControl.mouseDown)
				return;
			
			var rect:Rectangle = content.getBounds(content.parent);
			var dy:Number = topRightControl.position.y - rect.y;
			content.y += dy;
			content.height -= dy;
			
			content.width = topRightControl.position.x - leftLineControl.x;
			
			updateControls();
		}

		private function bottomLeftControlHandler(event:MoveEvent):void
		{
			if (!bottomLeftControl.mouseDown)
				return;
			
			var rect:Rectangle = content.getBounds(content.parent);
			var dx:Number = bottomLeftControl.position.x - rect.x;
			content.x += dx;
			content.width -= dx;
			
			content.height = bottomLeftControl.position.y - topLineControl.position.y;
			
			updateControls();
		}
		
		private function bottomRightControlHandler(event:MoveEvent):void
		{
			if (!bottomRightControl.mouseDown)
				return;
			
			content.height = bottomRightControl.position.y - topLineControl.position.y;
			content.width = bottomRightControl.position.x - leftLineControl.x;
			
			updateControls();
		}
		private function fillMouseDownHandler(event:MoveEvent):void
		{
			if (!fillControl.mouseDown)
				return;
			
			var rect:Rectangle = content.getBounds(content.parent);
			content.x += fillControl.x - rect.x;
			content.y += fillControl.y - rect.y;
			
			updateControls()
		}
		/** @inheritDoc*/
		override public function destory():void
		{
			this.content = null;
			
			super.destory();
		}
	}
}