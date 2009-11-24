package ghostcat.community.physics
{
	import flash.geom.Point;

	/**
	 * 物理管理器，提供一些控制物理属性的方法
	 * @author flashyiyi
	 * 
	 */
	public final class PhysicsUtil
	{
		/**
		 * 爆炸 
		 * @param p	起爆点
		 * @param power
		 * 
		 */
		public static function bomb(physics:PhysicsManager,p:Point,power:Number = 5,spin:Number = 10):void
		{
			for each (var item:PhysicsItem in physics.data)
			{
				var offest:Point = new Point(item.x,item.y).subtract(p);
				
				item.velocity = new Point(power * offest.x,power * offest.y);
				item.spin = (Math.random() - 0.5) * spin * 2;
				item.scaleSpeed = Math.pow(0.5, offest.length / 50) / 50;
				
				item.friction = 0.95;
				item.spinFriction = 0.99;
			}
		}
		
		/**
		 * 吸引力 
		 * @param physics
		 * @param p
		 * @param power
		 * 
		 */
		public static function attract(physics:PhysicsManager,p:Point,power:Number = 5):void
		{
			
		}
	}
}