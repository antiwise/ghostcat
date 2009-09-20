package ghostcat.display.graphics
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ghostcat.display.GBase;
	import ghostcat.skin.PointSkin;
	import ghostcat.util.CallLater;
	import ghostcat.util.ClassFactory;

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
			setPoint(v);
		}
		
		/**
		 * 设置坐标
		 * 
		 * @param v
		 * @param silence	是否触发Move事件
		 * 
		 */
		public function setPoint(v:Point,silence:Boolean = false):void
		{
			_point = v;
			if (v)
			{
				if (silence)
				{
					$x = _point.x;
					$y = _point.y;
				}
				else
				{
					x = _point.x;
					y = _point.y;
				}
			}
		}
		
		private var localMousePoint:Point;//按下时的鼠标位置
		
		/**
		 * 鼠标是否按下
		 */
		public function get mouseDown():Boolean
		{
			return localMousePoint!=null;
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
			
			this.cursor = "drag";
			enabled = enabled;
			
//			this.delayUpatePosition = true;//设置此属性是为了消除闪烁
		}

		public function onMouseDownHandler(event : MouseEvent) : void
		{
			if (enabled)
			{
				localMousePoint = new Point(x - parent.mouseX,y - parent.mouseY);
				
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			}
		}

		public function onMouseUpHandler(event : MouseEvent) : void
		{
			localMousePoint = null;
			
			invalidatePosition();
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
		}

		public function onMouseMoveHandler(event : MouseEvent) : void
		{
			if (!lockX)
				x = parent.mouseX + localMousePoint.x;
			if (!lockY)
				y = parent.mouseY + localMousePoint.y;
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