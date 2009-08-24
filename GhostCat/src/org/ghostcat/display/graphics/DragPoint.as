package org.ghostcat.display.graphics
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.ghostcat.core.ClassFactory;
	import org.ghostcat.display.GBase;
	import org.ghostcat.skin.code.PointSkin;

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
			
			enabled = enabled;
		}

		public function onMouseDownHandler(event : MouseEvent) : void
		{
			if (enabled)
			{
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			}
		}

		public function onMouseUpHandler(event : MouseEvent) : void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
		}

		public function onMouseMoveHandler(event : MouseEvent) : void
		{
			x = event.stageX;
			y = event.stageY;
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
	}
}