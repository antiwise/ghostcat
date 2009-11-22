package ghostcat.community.physics
{
	import flash.geom.Point;
	
	/**
	 * 物理对象
	 * @author flashyiyi
	 * 
	 */
	public class PhysicsItem
	{
		/**
		 * 目标
		 */
		public var target:*;
		
		/**
		 * 加速度
		 */
		public var acceleration:Point;
		
		/**
		 * 速度
		 */
		public var velocity:Point = new Point();
		
		/**
		 * 自旋角速度
		 */
		public var spin:Number = 0;
		
		/**
		 * 缩放速度
		 */
		public var scaleSpeed:Number = 0;
		
		/**
		 * 速度衰减系数
		 */
		public var friction:Number = 1;
		
		/**
		 * 自旋衰减系数
		 */
		public var spinFriction:Number = 1;
		
		private var _scale:Number = 1.0;
		
		/**
		 * 缩放衰减系数
		 */
		public var scaleFriction:Number = 1;
		
		public function get y():Number
		{
			return target.y;
		}
		
		public function set y(v:Number):void
		{
			target.y = v;
		}
		
		public function get x():Number
		{
			return target.x;
		}
		
		public function set x(v:Number):void
		{
			target.x = v;
		}
		
		public function get rotation():Number
		{
			return target.rotation;
		}
		
		public function set rotation(v:Number):void
		{
			target.rotation = v;
		}
		
		public function get scale():Number
		{
			return _scale;
		}
		
		public function set scale(v:Number):void
		{
			target.scaleX = target.scaleY = _scale = v;
		}
		
		public function PhysicsItem(target:*)
		{
			this.target = target;
		}
	}
}