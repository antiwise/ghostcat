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
	 * 缩放盒子（不干涉原图元）
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
		private function setContentRect(x:Number = NaN,y:Number = NaN,width:Number = NaN ,height:Number = NaN):void
		{
			if (!isNaN(x))
				content.x = x > content.x + content.width ? content.x + content.width : x;
			if (!isNaN(y))
				content.y = y > content.y + content.height ? content.y + content.height : y;
			if (!isNaN(width))
				content.width = width > 0 ? width : 0;
			if (!isNaN(height))
				content.height = height > 0 ? height : 0;
		}
		
		private function topLeftControlHandler(event:MoveEvent):void
		{
			if (!topLeftControl.mouseDown)
				return;
			
			var rect:Rectangle = content.getBounds(content);
			setContentRect(
				content.x + topLeftControl.position.x - rect.x - content.x,
				content.y + topLeftControl.position.y - rect.y - content.y,
				rightLineControl.position.x - topLeftControl.position.x,
				bottomLineControl.position.y - topLeftControl.position.y
			)
			updateControls();
		}
		
		private function topRightControlHandler(event:MoveEvent):void
		{
			if (!topRightControl.mouseDown)
				return;
			
			var rect:Rectangle = content.getBounds(content);
			setContentRect(
				NaN,
				content.y + topRightControl.position.y - rect.y - content.y,
				topRightControl.position.x - leftLineControl.position.x,
				bottomLineControl.position.y - topRightControl.position.y
			)
			
			updateControls();
		}
		
		private function bottomLeftControlHandler(event:MoveEvent):void
		{
			if (!bottomLeftControl.mouseDown)
				return;
			
			var rect:Rectangle = content.getBounds(content);
			setContentRect(
				content.x + bottomLeftControl.position.x - rect.x - content.x,
				NaN,
				rightLineControl.position.x - bottomLeftControl.position.x,
				bottomLeftControl.position.y - topLineControl.position.y
			)
			
			updateControls();
		}
		
		private function bottomRightControlHandler(event:MoveEvent):void
		{
			if (!bottomRightControl.mouseDown)
				return;
			
			setContentRect(
				NaN,
				NaN,
				bottomRightControl.position.x - leftLineControl.position.x,
				bottomRightControl.position.y - topLineControl.position.y
			)
			
			updateControls();
		}
		private function leftLineControlHandler(event:MoveEvent):void
		{
			if (!leftLineControl.mouseDown)
				return;
			
			var rect:Rectangle = content.getBounds(content);
			setContentRect(
				content.x + leftLineControl.position.x - rect.x - content.x,
				NaN,
				rightLineControl.position.x - leftLineControl.position.x,
				NaN
			)
			
			updateControls();
		}
		
		private function topLineControlHandler(event:MoveEvent):void
		{
			if (!topLineControl.mouseDown)
				return;
			
			var rect:Rectangle = content.getBounds(content);
			setContentRect(
				NaN,
				content.y + topLineControl.position.y - rect.y - content.y,
				NaN,
				bottomLineControl.position.y - topLineControl.position.y
			)
			
			updateControls();
		}
		
		private function rightLineControlHandler(event:MoveEvent):void
		{
			if (!rightLineControl.mouseDown)
				return;
			
			setContentRect(
				NaN,
				NaN,
				rightLineControl.position.x - leftLineControl.position.x,
				NaN
			)
			
			updateControls();
		}
		
		private function bottomLineControlHandler(event:MoveEvent):void
		{
			if (!bottomLineControl.mouseDown)
				return;
			
			setContentRect(
				NaN,
				NaN,
				NaN,
				bottomLineControl.position.y - topLineControl.position.y
			)
			
			updateControls();
		}
		private function fillMouseDownHandler(event:MoveEvent):void
		{
			if (!fillControl.mouseDown)
				return;
			
			var rect:Rectangle = content.getBounds(content);
			setContentRect(
				content.x + fillControl.position.x - rect.x - content.x,
				content.y + fillControl.position.y - rect.y - content.y,
				NaN,
				NaN
			)
			
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