package ghostcat.transfer
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 提供3D旋转功能（沿X,Y轴旋转只能选其一）
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class Paper3D extends Skew
	{
		/**
		 * 近景最大缩放比
		 */
		public var maxScale:Number = 0.5;
		
		private var _rotationX:Number = 0;
		private var _rotationY:Number = 0;
		
		public function Paper3D(target:DisplayObject, vP:Number=4, hP:Number=4)
		{
			super(target, vP, hP);
		}
		
		/**
		 * 沿X轴旋转角度
		 * @return 
		 * 
		 */
		public function get rotationX():Number
		{
			return _rotationX;
		}

		public function set rotationX(v:Number):void
		{
			_rotationX = v;
			
			var rect: Rectangle = _target.getBounds(_target);
			var r:Number = v / 180 * Math.PI;
			var dx:Number = rect.width/2 * Math.sin(r) * maxScale;
			var dy:Number = rect.height/2 * (1 - Math.cos(r));
			var _topLeft:Point = new Point(rect.x + dx,rect.y + dy);
			var _bottomLeft:Point = new Point(rect.x - dx,rect.bottom - dy);
			var _topRight:Point = new Point(rect.right - dx,rect.y + dy);
			var _bottomRight:Point = new Point(rect.right + dx,rect.bottom - dy);
			
			setTransform(_topLeft,_topRight,_bottomLeft,_bottomRight)
		}
		
		/**
		 * 沿Y轴旋转角度
		 * @return 
		 * 
		 */
		public function get rotationY():Number
		{
			return _rotationY;
		}

		public function set rotationY(v:Number):void
		{
			_rotationY = v;
			
			var rect: Rectangle = _target.getBounds(_target);
			var r:Number = v / 180 * Math.PI;
			var dx:Number = rect.width/2 * (1 - Math.cos(r));
			var dy:Number = rect.height/2 * Math.sin(r) * maxScale;
			var _topLeft:Point = new Point(rect.x + dx,rect.y + dy)
			var _bottomLeft:Point = new Point(rect.x + dx,rect.bottom - dy)
			var _topRight:Point = new Point(rect.right - dx,rect.y - dy)
			var _bottomRight:Point = new Point(rect.right - dx,rect.bottom + dy)
			
			setTransform(_topLeft,_topRight,_bottomLeft,_bottomRight)
		}

	}
}