package org.ghostcat.display.transfer
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Paper3D extends Skew
	{
		public var maxScale:Number = 0.5;
		
		private var _rotationZ:Number = 0;
		
		public function Paper3D(target:DisplayObject, vP:Number=4, hP:Number=4)
		{
			super(target, vP, hP);
		}

		public function get rotationZ():Number
		{
			return _rotationZ;
		}

		public function set rotationZ(v:Number):void
		{
			_rotationZ = v;
			
			var r:Number = Math.sin(v / 180 * Math.PI);
			var rect: Rectangle = _target.getBounds(_target);
			var w2:Number = rect.width/2;
			var h2:Number = rect.height/2;
			var _topLeft:Point = new Point(rect.x + Math.abs(w2 * r),rect.y + h2 * r * maxScale)
			var _bottomLeft:Point = new Point(rect.x + Math.abs(w2 * r),rect.bottom - h2 * r * maxScale)
			var _topRight:Point = new Point(rect.right - Math.abs(w2 * r),rect.y - h2 * r * maxScale)
			var _bottomRight:Point = new Point(rect.right - Math.abs(w2 * r),rect.bottom + h2 * r * maxScale)
			
			setTransform(_topLeft,_topRight,_bottomLeft,_bottomRight)
		}

	}
}