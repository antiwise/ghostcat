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
		 * 速度衰减系数
		 */
		public var friction:Number = 1;
		
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
		
		public function PhysicsItem(target:*)
		{
			this.target = target;
		}
	}
}