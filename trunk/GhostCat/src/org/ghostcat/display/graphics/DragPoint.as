package org.ghostcat.display.graphics
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.ghostcat.core.ClassFactory;
	import org.ghostcat.display.GBase;
	import org.ghostcat.skin.code.PointSkin;
	import org.ghostcat.util.CallLater;

	/**
	 * 可拖动操控点
	 * 可监听其MoveEvent事件来执行操作
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class DragPoint extends GBase
	{
		public static var defaultSkin:ClassFactory = new ClassFactory(PointSkin);
		
		public var lockX:Boolean = false;
		public var lockY:Boolean = false;
		
		private var _point : Point = new Point();

		/**
		 * 坐标
		 */
		public function get point():Point
		{
			return _point;
		}

		public function set point(v:Point):void
		{
			_point = v;
			if (_point)
			{
				x = _point.x;
				y = _point.y;
			}
		}
		
		/**
		 * 鼠标是否按下
		 */
		public var mouseDown:Boolean = false;

		/**
		 * 
		 * @param skin	皮肤
		 * @param replace	是否替换
		 * @param point	由外部引入坐标对象，位置的更改将会应用到此对象上
		 * 
		 */
		public function DragPoint(point:Point=null,skin:DisplayObject=null,replace:Boolean=true) : void
		{
			if (!skin)
				skin = defaultSkin.newInstance();
			
			super(skin, replace);
			
			if (!point)
				point = new Point();
			
			this.point = point;
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			
			this.cursor = "drag";
			enabled = enabled;
			
			this.delayUpatePosition = true;//这样做是为了避免反复设置属性。invalidatePosition已经被重写为立即执行了，所以并不会产生属性延迟。
		}

		public function onMouseDownHandler(event : MouseEvent) : void
		{
			if (enabled)
			{
				mouseDown = true;
				
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			}
		}

		public function onMouseUpHandler(event : MouseEvent) : void
		{
			mouseDown = false;
			
			invalidatePosition();
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
		}

		public function onMouseMoveHandler(event : MouseEvent) : void
		{
			if (!lockX)
				x = parent.mouseX;
			if (!lockY)
				y = parent.mouseY;
		}

		override public function set x(value : Number) : void
		{
			point.x = super.x = value;
		}

		override public function set y(value : Number) : void
		{
			point.y = super.y = value;
		}

		public override function set enabled(value : Boolean) : void
		{
			mouseEnabled = super.enabled = value;
		}
		
		public override function invalidatePosition() : void
		{
			CallLater.callLater(vaildPosition,null,true);
		}
	}
}